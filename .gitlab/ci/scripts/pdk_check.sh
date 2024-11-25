#!/bin/bash

function header() { echo -ne "\n${1}\n"; }
function fail() { echo -ne "${1}"; }
function pass() { echo -ne "${1}"; }

function use_pdk() {
  path_to_pdk=$(command -v pdk)
  if [[ -n "$path_to_pdk" ]]; then
    pdk_version=$(${path_to_pdk} --version)
    return 0
  else
    return 1
  fi
}

function setup_paths() {
  # Prefer the PDK by default
  if use_pdk; then
    path_to_puppet="${path_to_pdk} bundle exec puppet"
    path_to_puppet_lint="${path_to_pdk} bundle exec puppet-lint"
    path_to_erb="${path_to_pdk} bundle exec erb"
    path_to_ruby="${path_to_pdk} bundle exec ruby"
  fi
}

function checkyaml() {
  if [ -n "$path_to_pdk" ] && { [ $(cut -d. -f1 <<<$pdk_version) -gt 1 ] || [ $(cut -d. -f2 <<<$pdk_version) -ge 9 ]; }; then
    $path_to_pdk validate yaml "$1"
  else
    $path_to_ruby -e "require 'yaml'; YAML.load_file('$1')"
  fi
}

setup_paths

if [[ $(git diff --name-only origin/production | grep '\.pp'$) ]]; then
  header "*** Checking puppet code for style ***"
  for file in $(git diff --name-only origin/production | grep '\.pp'$); do
    # Only check new/modified files that end in *.pp extension
    if [[ -f $file && $file == *.pp ]]; then
      # allow user-defined over-ride of linting rules with .puppet-lint.rc
      if [[ -f "$(git rev-parse --show-toplevel)/.puppet-lint.rc" ]]; then
        $path_to_puppet_lint --config "$(git rev-parse --show-toplevel)/.puppet-lint.rc" "$file"
      else
        $path_to_puppet_lint --with-filename "$file"
      fi

      # Set us up to bail if we receive any syntax errors
      if [[ $? -ne 0 ]]; then
        fail "FAILED: "; echo "$file"
        syntax_is_bad=1
      else
        pass "PASSED: "; echo "$file"
      fi
    fi
  done

  header "*** Checking puppet manifest syntax ***"
  for file in $(git diff --name-only origin/production | grep -E '\.(pp)'); do
    if [[ -f $file && $file == *.pp ]]; then
      $path_to_puppet parser validate $file
      if [[ $? -ne 0 ]]; then
        fail "FAILED: "; echo "$file"
        syntax_is_bad=1
      else
        pass "PASSED: "; echo "$file"
      fi
    fi
  done
fi

if [[ ! -z $(git diff --name-only origin/production | grep -E manifests/site.pp) ]]; then
  header "*** Checking if the catalog compiles ***"
  $path_to_puppet apply --noop manifests/site.pp
  if [[ $? -ne 0 ]]; then
    fail "FAILED: "; echo "catalog compilation"
    syntax_is_bad=1
  else
    pass "PASSED: "; echo "catalog compilation"
  fi
fi

if [[ $(git diff --name-only origin/production | grep -E '\.(epp)') ]]; then
  header "*** Checking puppet template(epp) syntax ***"
  for file in $(git diff --name-only origin/production | grep -E '\.(epp)'); do
    if [[ -f $file && $file == *.epp ]]; then
      $path_to_puppet epp validate $file
      if [[ $? -ne 0 ]]; then
        fail "FAILED: "; echo "$file"
        syntax_is_bad=1
      else
        pass "PASSED: "; echo "$file"
      fi
    fi
  done
fi

if [[ $(git diff --name-only origin/production | grep -E '\.(erb$)') ]]; then
  header "*** Checking ruby template(erb) syntax ***"
  for file in $(git diff --name-only origin/production | grep -E '\.(erb$)'); do
    if [[ -f $file ]]; then
      $path_to_erb -P -x -T '-' $file | $path_to_ruby -c | grep -v '^Syntax OK'
      if [[ "${PIPESTATUS[1]}" -ne 0 ]]; then
        fail "FAILED: "; echo "$file"
        syntax_is_bad=1
      else
        pass "PASSED: "; echo "$file"
      fi
    fi
  done
fi

if [[ $(git diff --name-only origin/production | grep -E '\.(rb$)') ]]; then
  header "*** Checking ruby syntax ***"
  for file in $(git diff --name-only origin/production | grep -E '\.(rb$)'); do
    if [[ -f $file ]]; then
      $path_to_ruby -c $file | grep -v '^Syntax OK'
      if [[ "${PIPESTATUS[0]}" -ne 0 ]]; then
        fail "FAILED: "; echo "$file"
        syntax_is_bad=1
      else
        pass "PASSED: "; echo "$file"
      fi
    fi
  done
fi

if [[ $(git diff --name-only origin/production | grep -E '\.(yaml$|yml$)') ]]; then
  header "*** Checking YAML syntax ***"
  for file in $(git diff --name-only origin/production | grep -E '\.(yaml$|yml$)'); do
    if [[ -f $file ]]; then
      checkyaml $file
      if [[ $? -ne 0 ]]; then
        fail "FAILED: "; echo "$file"
        syntax_is_bad=1
      else
        pass "PASSED: "; echo "$file"
      fi
    fi
  done
fi

if [[ $syntax_is_bad -eq 1 ]]; then
  fail "\nErrors Found, REJECTED\n"
  exit 1
else
  pass "\nNo Errors Found, ACCEPTED\n"
fi
