# Filebeats default params

class filesbeats::params {
  $export_log_paths    = ['/var/log/*.log']
  $shield_username     = ''
  $shield_password     = ''
  $elasticsearch_proxy_host = 'localhost:9200'
  case $::osfamily {
    'Debian': {
      $export_log_paths    = ['/var/log/*.log']
      $config_path    = '/etc/filebeat'
    }
    default: {
      fail('Could not determine default params for your Operating System')
    }
  }
}
