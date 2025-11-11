# Basic setup of filebeats repository and installtion
# More details see: https://www.elastic.co/guide/en/beats/libbeat/current/setup-repositories.html
class filebeats::package {
  case $facts['os']['family'] {
    'Debian': {
      package {'filebeat':
        ensure  => present,
        require => Class['::elastic_stack::repo']
      }
      Class['apt::update'] -> Package['filebeat']
    }
    default: {
      fail('Could not configure apt resource for elasticsearch filebeats')
    }
  }

}
