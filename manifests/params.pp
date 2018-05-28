# Filebeats default params

class filebeats::params {
  $shield_username             = ''
  $service_bootstrapped        = true
  $service_state               = 'running'
  $loadbalance                 = false
  $shield_password             = ''
  $logstash_hosts              = []
  $logstash_index              = ''
  $elasticsearch_proxy_host    = 'localhost:9200'
  $elasticsearch_protocol      = 'http'
  $elasticsearch_index         = ''
  $use_ssl                     = false
  $ssl_certificate_authorities = []
  $ssl_certificate             =  ''
  $ssl_certificate_key         =  ''
  $prospectors                 = []
  $log_settings                =  {
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
      $export_log_paths = ['/var/log/*.log']
      $config_path      = '/etc/filebeat'
    }
    default: {
      fail('Could not determine default params for your Operating System')
    }
  }
}
