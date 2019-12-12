# Filebeats default params

class filebeats::params {
  $elasticsearch_hosts                       = []
  $elasticsearch_index                       = ''
  $elasticsearch_password                    = ''
  $elasticsearch_protocol                    = 'http'
  $elasticsearch_ssl_certificate             = ''
  $elasticsearch_ssl_certificate_authorities = []
  $elasticsearch_ssl_certificate_key         = ''
  $elasticsearch_template_enabled            = false
  $elasticsearch_template_name               = ''
  $elasticsearch_template_overwrite          = false
  $elasticsearch_template_path               = ''
  $elasticsearch_username                    = ''
  $logstash_hosts                            = []
  $logstash_index                            = ''
  $logstash_bulk_max_size                    = 2048
  $logstash_loadbalance                      = false
  $logstash_worker                           = 1
  $logstash_ssl_certificate                  = ''
  $logstash_ssl_certificate_authorities      = []
  $logstash_ssl_certificate_key              = ''
  $logstash_ttl                              = ''
  $prospectors                               = []
  $service_bootstrapped                      = true
  $service_state                             = 'running'
  $log_settings                              =  {
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
    'RedHat': {
      $export_log_paths = ['/var/log/*.log']
      $config_path      = '/etc/filebeat'
    }
    default: {
      fail('Could not determine default params for your Operating System')
    }
  }
}
