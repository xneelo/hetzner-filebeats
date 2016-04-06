#Basic filebeat configuration
# Params:
#   export_log_paths: Array of Strings - path to log files to export.
#   shield_username: String - Username for shield authentication.
#   shield_password: String - Password for shield authentication.
#More details on shield: https://www.elastic.co/guide/en/shield/current/getting-started.html

class filebeats::config (
  $export_log_paths,
  $shield_username,
  $shield_password,
  $elasticsearch_proxy_host,
  $elasticsearch_protocol,
  $tls_certificate_authorities,
  $tls_certificate,
  $tls_certificate_key,
  $log_settings,
){
  $config_path = $filebeats::params::config_path

  if empty($log_settings) {
    $logging = {}
  } else {
    $logging = merge($::filebeats::params::log_settings, $log_settings)
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
