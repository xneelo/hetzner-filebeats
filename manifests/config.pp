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
){
  $config_path = $::filebeat::params::config_path

  file {"${config_path}/filebeat.yml":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0640',
    content => template('modules/filebeat/filebeat.yml.erb'),
  }

}
