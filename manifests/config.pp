#Basic filebeat configuration
#More details: https://www.elastic.co/guide/en/beats/filebeat/current/configuring-howto-filebeat.html

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
  Hash    $modules,
  String  $modules_conf_dir,
  Array   $inputs,
  Hash    $ilm,
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

  if empty($inputs) {
    validate_array($export_log_paths)

    $inputs_array =  [{ 'paths'      => $export_log_paths,
                        'input_type' => 'log',
                        'doc_type'   => 'log'
                      }]
  } else {
    $inputs_array = $inputs
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

#TODO turn this into a puppet resource
  $modules.each | String $action, Array $module_name | {
    $module_name.each | String $module| {
      if $action == 'enable' {
        exec { "filebeat_${module}_${action}":
          command => "filebeat modules ${action} ${module}",
          creates => "${modules_conf_dir}/${module}.yml",
          require => Package['filebeat'],
          notify  => Service['filebeat'],
        }
      } else {
        exec { "filebeat_${module}_${action}":
          command => "filebeat modules ${action} ${module}",
          creates => "${modules_conf_dir}/${module}.yml.disabled",
          require => Package['filebeat'],
          notify  => Service['filebeat'],
        }
      }
    }
  }

}
