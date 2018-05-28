#Basic filebeat configuration
# Params:
#   export_log_paths: Array of Strings - path to log files to export.
#   shield_username: String - Username for shield authentication.
#   shield_password: String - Password for shield authentication.
#More details on shield: https://www.elastic.co/guide/en/shield/current/getting-started.html

class filebeats::config (
  $export_log_paths,
  $prospectors,
  $shield_username,
  $shield_password,
  $elasticsearch_proxy_host,
  $elasticsearch_protocol,
  $ssl_certificate_authorities,
  $ssl_certificate,
  $ssl_certificate_key,
  $loadbalance,
  $log_settings,
  $logstash_hosts,
  $logstash_index,
  $elasticsearch_index,
){
  $config_path = $filebeats::params::config_path

  if empty($log_settings) {
    $logging = {}
  } else {
    $logging = merge($::filebeats::params::log_settings, $log_settings)
  }

  if empty($prospectors) {
    validate_array($export_log_paths)

    $prospectors_array =  [{'paths'         => $export_log_paths,
                            'input_type'    => 'log',
                            'doc_type' => 'log'
                          }]
  } else {
    $prospectors_array = $prospectors
  }

  file {"${config_path}/filebeat.yml":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0640',
    content => template('filebeats/filebeat.yml.erb'),
    require => Package['filebeat'],
    notify  => Service['filebeat'],
  }

}
