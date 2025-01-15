#Basic filebeat configuration
#More details: https://www.elastic.co/guide/en/beats/filebeat/current/configuring-howto-filebeat.html

# Class: filebeats::config
#
# @summary Configure Filebeat to ship logs to Elasticsearch, Logstash, and Kibana.
#
#   @param elasticsearch_hosts
#     List of Elasticsearch hosts.
#
#   @param elasticsearch_index
#     Elasticsearch index name.
#
#   @param elasticsearch_password
#     Password for Elasticsearch authentication.
#
#   @param elasticsearch_protocol
#     Protocol to use for Elasticsearch (e.g., http, https).
#
#   @param elasticsearch_ssl_certificate
#     Path to the SSL certificate for Elasticsearch.
#
#   @param elasticsearch_ssl_certificate_authorities
#     List of paths to the SSL certificate authorities for Elasticsearch.
#
#   @param elasticsearch_ssl_certificate_key
#     Path to the SSL certificate key for Elasticsearch.
#
#   @param elasticsearch_template_enabled
#     Whether to enable Elasticsearch template.
#
#   @param elasticsearch_template_name
#     Name of the Elasticsearch template.
#
#   @param elasticsearch_template_overwrite
#     Whether to overwrite the existing Elasticsearch template.
#
#   @param elasticsearch_template_path
#     Path to the Elasticsearch template file.
#
#   @param elasticsearch_username
#     Username for Elasticsearch authentication.
#
#   @param export_log_paths
#     List of paths to export logs from.
#
#   @param kibana_url
#     URL of the Kibana instance.
#
#   @param log_settings
#     Settings for logging.
#
#   @param logstash_hosts
#     List of Logstash hosts.
#
#   @param logstash_bulk_max_size
#     Maximum size of bulk requests to Logstash.
#
#   @param logstash_index
#     Logstash index name.
#
#   @param logstash_loadbalance
#     Whether to enable load balancing for Logstash.
#
#   @param logstash_worker
#     Number of workers for Logstash.
#
#   @param logstash_ssl_certificate
#     Path to the SSL certificate for Logstash.
#
#   @param logstash_ssl_certificate_authorities
#     List of paths to the SSL certificate authorities for Logstash.
#
#   @param logstash_ssl_certificate_key
#     Path to the SSL certificate key for Logstash.
#
#   @param logstash_ttl
#     Time-to-live for Logstash events.
#
#   @param modules
#     Configuration for Filebeat modules.
#
#   @param modules_conf_dir
#     Directory for Filebeat module configurations.
#
#   @param inputs
#     List of input configurations for Filebeat.
#
#   @param ilm_check_exits
#     Whether to check if ILM (Index Lifecycle Management) exists.
#
#   @param ilm_enabled
#     Whether ILM is enabled.
#
#   @param ilm_overwrite
#     Whether to overwrite existing ILM policies.
#
#   @param ilm_pattern
#     Pattern for ILM indices.
#
#   @param ilm_policy_file
#     Path to the ILM policy file.
#
#   @param ilm_policy_name
#     Name of the ILM policy.
#
#   @param ilm_rollover_alias
#     Rollover alias for ILM.
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
  Boolean $ilm_check_exits,
  String  $ilm_enabled,
  Boolean $ilm_overwrite,
  String  $ilm_pattern,
  String  $ilm_policy_file,
  String  $ilm_policy_name,
  String  $ilm_rollover_alias,
) {
  $config_path = $filebeats::params::config_path

  if empty($log_settings) {
    $logging = {}
  } else {
    $logging = stdlib::merge($filebeats::params::log_settings, $log_settings)
  }

  if !empty($logstash_ttl) {
    if $logstash_ttl !~ /^\-?[0-9]+\.?[0-9]*(?:ns|us|ms|s|m|h)$/ {
      fail("Parameter \$logstash_ttl with content '${logstash_ttl}': is not a valid elastic duration")
    }
  }

  if empty($inputs) {
    validate_array($export_log_paths)

    $inputs_array = [{
        'paths'      => $export_log_paths,
        'input_type' => 'log',
        'doc_type'   => 'log'
    }]
  } else {
    $inputs_array = $inputs
  }

  if ! ($ilm_enabled in [ 'auto', 'true', 'false' ]) {
    fail("Parameter \$ilm_enabled with content '${ilm_enabled}': must be one of [ 'auto', 'true', 'false' ]")
  }

  file { "${config_path}/filebeat.yml":
    ensure  => file,
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
          onlyif  => "[ -e ${modules_conf_dir}/${module}.yml.disabled ]",
          require => Package['filebeat'],
          notify  => Service['filebeat'],
        }
      } else {
        exec { "filebeat_${module}_${action}":
          command => "filebeat modules ${action} ${module}",
          creates => "${modules_conf_dir}/${module}.yml.disabled",
          onlyif  => "[ -e ${modules_conf_dir}/${module}.yml ]",
          require => Package['filebeat'],
          notify  => Service['filebeat'],
        }
      }
    }
  }
}
