#Basic filebeat configuration
# Params:
#   export_log_paths: Array of Strings - path to log files to export.
#   shield_username: String - Username for shield authentication.
#   shield_password: String - Password for shield authentication.
#More details on shield: https://www.elastic.co/guide/en/shield/current/getting-started.html

class filebeats::config (
  Array   $elasticsearch_hosts,
  String  $elasticsearch_index,
  String  $elasticsearch_password,
  String  $elasticsearch_protocol,
  String  $elasticsearch_ssl_certificate,
  Array   $elasticsearch_ssl_certificate_authorities,
  String  $elasticsearch_ssl_certificate_key,
  Boolean $elasticsearch_template_enabled,
  String  $elasticsearch_template_name,
  Boolean $elasticsearch_template_overwrite,
  String  $elasticsearch_template_path,
  String  $elasticsearch_username,
  Array   $export_log_paths,
  String  $kibana_url,
  Hash    $log_settings,
  Array   $logstash_hosts,
  Integer $logstash_bulk_max_size,
  String  $logstash_index,
  Boolean $logstash_loadbalance,
  Integer $logstash_worker,
  String  $logstash_ssl_certificate,
  Array   $logstash_ssl_certificate_authorities,
  String  $logstash_ssl_certificate_key,
  String  $logstash_ttl,
  Array   $prospectors,
){
  $config_path = $filebeats::params::config_path

  if empty($log_settings) {
    $logging = {}
  } else {
    $logging = merge($::filebeats::params::log_settings, $log_settings)
  }

  if !empty($logstash_ttl) {
    if $logstash_ttl !~ /^\-?[0-9]+\.?[0-9]*(?:ns|us|ms|s|m|h)$/ {
      fail("Parameter \$logstash_ttl with content '${logstash_ttl}': is not a valid elastic duration")
    }
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
