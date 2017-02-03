# Basic setup of filebeats repository and installtion
# More details see: https://www.elastic.co/guide/en/beats/libbeat/current/setup-repositories.html
class filebeats::package {
  case $::osfamily {
    'Debian': {
      include ::apt
      apt::source {'filebeats':
        location    => 'http://packages.elastic.co/beats/apt',
        release     => 'stable',
        repos       => 'main',
        key         => {
          'id'        => '46095ACC8548582C1A2699A9D27D666CD88E42B4',
          'server'    => 'pool.sks-keyservers.net',
        },
        include     => {
          'deb' => true,
          'src' => false,
        },
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
