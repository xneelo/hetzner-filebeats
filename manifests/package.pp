# Basic setup of filebeats repository and installtion
# More details see: https://www.elastic.co/guide/en/beats/libbeat/current/setup-repositories.html
class filebeats::package {
  case $::osfamily {
    'Debian': {
      package {'filebeat':
        ensure  => present,
        require => Class['::elastic_stack::repo']
      }
    }
    'RedHat': {
      exec { 'Import Elastic GPG key':
        command => '/bin/rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch',
        cwd     => '/etc/pki/rpm-gpg',
        unless  => '/bin/rpm -qa gpg-pubkey\* --qf "%{name}-%{version}-%{release}-%{summary}\n" | grep -i elasticsearch',
        before  => File['elastic-5.x repo'],
      }
      file { 'elastic-5.x repo':
        ensure => 'present',
        path   => '/etc/yum.repos.d/elastic.repo',
        owner  => 'root',
        group  => 'root',
        source => 'puppet:///modules/filebeats/elastic.repo',
      }
      package {'filebeat':
        ensure => present,
      }
    }
    default: {
      fail('Could not configure apt resource for elasticsearch filebeats')
    }
  }

}
