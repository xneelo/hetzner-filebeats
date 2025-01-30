# Filebeats default params
#
# This class contains the default parameters for configuring Filebeats.
# It includes settings for Elasticsearch, Logstash, ILM, and logging.
#
class filebeats::params {
  $elasticsearch_hosts                       = []
  $elasticsearch_index                       = ''
  $elasticsearch_ilm                         = false
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
  $modules                                   = {
    enable  => [],
    disable => [],
  }
  $modules_conf_dir                          = '/etc/filebeat/modules.d'
  $ilm_check_exits                           = true
  $ilm_enabled                               = 'auto'
  $ilm_overwrite                             = false
  $ilm_pattern                               = ''
  $ilm_policy_file                           = ''
  $ilm_policy_name                           = ''
  $ilm_rollover_alias                        = ''
  $inputs                                    = []
  $service_bootstrapped                      = true
  $service_state                             = 'running'
  $log_settings                              = {
    level => 'error',
    to_syslog => false,
    to_files  => true,
    path  => '/var/log/filebeat',
    keepfiles => 7,
    name  => 'filebeats.log',
    rotateeverybytes => 10485760,
  }
  case $facts['os']['family'] {
    'Debian': {
      $export_log_paths = ['/var/log/*.log']
      $config_path      = '/etc/filebeat'
    }
    default: {
      fail('Could not determine default params for your Operating System')
    }
  }
}
