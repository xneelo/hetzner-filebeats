# This Puppet manifest configures Filebeat, a lightweight shipper for forwarding and centralizing log data.
# For more details on configuring Filebeat, refer to the official documentation:
# https://www.elastic.co/guide/en/beats/filebeat/current/configuring-howto-filebeat.html
# Parameters:
#
# @param elasticsearch_hosts
#   An array of Elasticsearch hosts to which Filebeats will send data.
#
# @param elasticsearch_index
#   The index name to use for Elasticsearch.
#
# @param elasticsearch_password
#   The password for Elasticsearch authentication.
#
# @param elasticsearch_protocol
#   The protocol to use for connecting to Elasticsearch (e.g., 'http' or 'https').
#
# @param elasticsearch_ssl_certificate
#   The path to the SSL certificate for Elasticsearch.
#
# @param elasticsearch_ssl_certificate_authorities
#   An array of paths to the SSL certificate authorities for Elasticsearch.
#
# @param elasticsearch_ssl_certificate_key
#   The path to the SSL certificate key for Elasticsearch.
#
# @param elasticsearch_template_enabled
#   Boolean to enable or disable Elasticsearch template.
#
# @param elasticsearch_template_name
#   The name of the Elasticsearch template.
#
# @param elasticsearch_template_overwrite
#   Boolean to enable or disable overwriting the Elasticsearch template.
#
# @param elasticsearch_template_path
#   The path to the Elasticsearch template file.
#
# @param elasticsearch_username
#   The username for authenticating with Elasticsearch.
#
# @param export_log_paths
#   An array of paths to the log files to be exported.
#
# @param kibana_url
#   The URL of the Kibana instance.
#
# @param log_settings
#   A hash of log settings.
#
# @param logstash_hosts
#   An array of Logstash hosts.
#
# @param logstash_bulk_max_size
#   The maximum size of bulk requests to Logstash.
#
# @param logstash_index
#   The index to use for Logstash.
#
# @param logstash_loadbalance
#   Boolean to enable or disable load balancing for Logstash.
#
# @param logstash_worker
#   The number of workers for Logstash.
#
# @param logstash_ssl_certificate
#   The path to the SSL certificate for Logstash.
#
# @param logstash_ssl_certificate_authorities
#   An array of paths to the SSL certificate authorities for Logstash.
#
# @param logstash_ssl_certificate_key
#   The path to the SSL certificate key for Logstash.
#
# @param logstash_ttl
#   The time-to-live (TTL) for Logstash events.
#
# @param modules
#   A hash of module configurations.
#
# @param modules_conf_dir
#   The directory for module configuration files.
#
# @param inputs
#   An array of input configurations.
#
# @param ilm_check_exits
#   Boolean to check if ILM (Index Lifecycle Management) exists.
#
# @param ilm_enabled
#   The status of ILM (enabled or disabled).
#
# @param ilm_overwrite
#   Boolean to enable or disable overwriting ILM policies.
#
# @param ilm_pattern
#   The pattern for ILM indices.
#
# @param ilm_policy_file
#   The path to the ILM policy file.
#
# @param ilm_policy_name
#   The name of the ILM policy.
#
# @param ilm_rollover_alias
#   The rollover alias for ILM.
#
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

  if ! ($ilm_enabled in ['auto', 'true', 'false']) {
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
