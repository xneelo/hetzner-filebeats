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
      package {'filebeat':
        ensure => present,
        require => Class['::elastic_stack::repo']
      }
    }
    default: {
      fail('Could not configure apt resource for elasticsearch filebeats')
    }
  }

}
