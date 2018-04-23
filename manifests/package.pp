# Basic setup of filebeats repository and installtion
# More details see: https://www.elastic.co/guide/en/beats/libbeat/current/setup-repositories.html
class filebeats::package {
  case $::osfamily {
    'Debian': {
      include ::apt
      apt::source {'filebeats':
        location => 'http://packages.elastic.co/beats/apt',
        release  => 'stable',
        repos    => 'main',
        key      => {
          'id'     => '46095ACC8548582C1A2699A9D27D666CD88E42B4',
          'server' => 'pool.sks-keyservers.net',
        },
        include  => {
          'deb' => true,
          'src' => false,
        },
      }
      package {'filebeat':
        ensure => present,
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
