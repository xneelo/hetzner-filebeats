# Filebeats default params

class filebeats::params {
  $shield_username          = ''
  $shield_password          = ''
  $elasticsearch_proxy_host = 'localhost:9200'
  $elasticsearch_protocol   = 'http'
  $tls_certificate_authorities = []
  $tls_certificate          =  ''
  $tls_certificate_key      =  ''
  $log_settings             = {
                                level => 'error',
                                to_syslog => false,
                                to_files  => true,
                                path  => '/var/log/filebeat',
                                keepfiles => 7,
                                name  => 'filebeats.log',
                                rotateeverybytes => 10485760,
                              }
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
