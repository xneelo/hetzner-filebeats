# Class: filebeats
# ===========================
#
# This module will install and configure a very basic filebeats installation.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `export_log_paths`
# An array of Strings that specifies which logs the filebeats application must export.
# * `inputs`
# An array of Hashes that specifies which groups of inputs (formally known as prospectors) log entries the filebeats application 
#  must export.
# * `elasticsearch_username`
# The username filebeats should use to authenticate should your cluster make use of elasticsearch
# * `elasticsearch_password`
# The password filebeats should use to authenticate should your cluster make use of elasticsearch
# * `elasticsearch_proxy_host`
# A string containing the hostname of your proxy host used for load balancing your cluster.
# If left empty it will default to exporting logs to your local host on port 9200.
# * `elasticsearch_protocol`
# A string containing the protocl used by filebeats to send logs.
# * `ssl_certificate_authorities`
# An array of Strings that specifies paths to Certificate authority files.
# * `ssl_certificate`
# A String that specifies a path to your hosts certificate to use when connecting to elasticsearch.
# * `ssl_certificate_key`
# A String that specifies a path to your hosts certificate key to use when connecting to elasticsearch.
# * `log_settings`
# A puppet Hash containing log level ('debug', 'warning', 'error' or 'critical'),
#  to_syslog(true/false), path('/var/log/filebeat'), keepfiles(7), rotateeverybytes(10485760), name(filebeats.log)
# * `service_bootstrapped`
# A boolean to turn on or off the filebeat service at boot ('false'/'true'), defaults to 'true'
# * `service_state`
# A string to describe the state of the filebeats service ('stopped'/'running'), defaults to 'running'
# *`loadbalance`
# A boolean to turn on or off load balancing for logstash outputs, defulats to false.
# *`logstash_hosts`
# An array of strings that specifies remote hosts to use for logstash outputs, e.g ['localhost:5044']
# *`logstash_index`
# A string that specifies the index to use for the logstash output, defaults to '[filebeat-]YYYY.MM.DD' as per the package.
# *`logstash_bulk_max_size`
# A number representing the maximum number of events to bulk in a single Logstash request, e.g 2048
#   Setting this to zero or negative disables the splitting of batches.
# *`logstash_ttl`
# A string that specifies the Time To Live for a connection to Logstash, you must use a elastic duration e.g. '5m', '1h', '45s'
#  see https://www.elastic.co/guide/en/beats/libbeat/master/config-file-format-type.html#_duration
#  NOTE: this option explicitly disables pipelining, it is not compatible with the async logstash client
#  https://www.elastic.co/guide/en/beats/filebeat/current/logstash-output.html#_literal_ttl_literal
# *`elasticsearch_index`
# A string that specifies the index to use for the elasticsearch output, defaults to '[filebeat-]YYYY.MM.DD' as per the package.
# *`elasticsearch_ilm`
# A boolean that specifies whether to enable Elastic's ILM option, defaults to false
# *`ilm_check_exits`
# A boolean when set to false, disables the check for an existing lifecycle policy. The default is true. You need to disable 
#  this check if the Filebeat user connecting to a secured cluster doesn’t have the read_ilm privilege
# *`ilm_enabled`
# A boolean that Enables or disables index lifecycle management on any new indices created by Filebeat. Valid values are
#  true, false, and auto
# *`ilm_overwrite`
# A boolean when set to true, the lifecycle policy is overwritten at startup
# *`ilm_pattern`
# A string that specifies the rollover index pattern. Date math is supported in this setting
# *`ilm_policy_file`
# A string that specifies the path to a JSON file that contains a lifecycle policy configuration. Use this setting to load your
#  own lifecycle policy
# *`ilm_policy_name`
# A string that specifies the name to use for the lifecycle policy
# *`ilm_rollover_alias`
# A string that specifies the index lifecycle write alias name
#
# Example
# --------
#
# @example
#    class { 'filebeats':
#      export_log_paths         => ['/var/log/auth.log'],
#      elasticsearch_username          => 'host',
#      elasticsearch_password          => 'secret',
#      elasticsearch_proxy_host => 'elasticsearchproxy.myserver.com',
#    }
#
# Authors
# -------
#
# Author Name <henlu.starke@hetzner.co.za>
#
# Copyright
# ---------
#
# Copyright 2016 Henlu Starke, unless otherwise noted.
#
class filebeats (
  $elasticsearch_hosts                       = $filebeats::params::elasticsearch_hosts,
  $elasticsearch_index                       = $filebeats::params::elasticsearch_index,
  $elasticsearch_ilm                         = $filebeats::params::elasticsearch_ilm,
  $elasticsearch_password                    = $filebeats::params::elasticsearch_password,
  $elasticsearch_protocol                    = $filebeats::params::elasticsearch_protocol,
  $elasticsearch_ssl_certificate             = $filebeats::params::elasticsearch_ssl_certificate,
  $elasticsearch_ssl_certificate_authorities = $filebeats::params::elasticsearch_ssl_certificate_authorities,
  $elasticsearch_ssl_certificate_key         = $filebeats::params::elasticsearch_ssl_certificate_key,
  $elasticsearch_template_enabled            = $filebeats::params::elasticsearch_template_enabled,
  $elasticsearch_template_name               = $filebeats::params::elasticsearch_template_name,
  $elasticsearch_template_overwrite          = $filebeats::params::elasticsearch_template_overwrite,
  $elasticsearch_template_path               = $filebeats::params::elasticsearch_template_path,
  $elasticsearch_username                    = $filebeats::params::elasticsearch_username,
  $export_log_paths                          = $filebeats::params::export_log_paths,
  $kibana_url                                = '',
  $log_settings                              = {},
  $logstash_hosts                            = $filebeats::params::logstash_hosts,
  $logstash_bulk_max_size                    = $filebeats::params::logstash_bulk_max_size,
  $logstash_index                            = $filebeats::params::logstash_index,
  $logstash_loadbalance                      = $filebeats::params::logstash_loadbalance,
  $logstash_ssl_certificate                  = $filebeats::params::logstash_ssl_certificate,
  $logstash_ssl_certificate_authorities      = $filebeats::params::logstash_ssl_certificate_authorities,
  $logstash_ssl_certificate_key              = $filebeats::params::logstash_ssl_certificate_key,
  $logstash_ttl                              = $filebeats::params::logstash_ttl,
  $logstash_worker                           = $filebeats::params::logstash_worker,
  $modules                                   = $filebeats::params::modules,
  $modules_conf_dir                          = $filebeats::params::modules_conf_dir,
  $ilm_check_exits                           = $filebeats::params::ilm_check_exits,
  $ilm_enabled                               = $filebeats::params::ilm_enabled,
  $ilm_overwrite                             = $filebeats::params::ilm_overwrite,
  $ilm_pattern                               = $filebeats::params::ilm_pattern,
  $ilm_policy_file                           = $filebeats::params::ilm_policy_file,
  $ilm_policy_name                           = $filebeats::params::ilm_policy_name,
  $ilm_rollover_alias                        = $filebeats::params::ilm_rollover_alias,
  $inputs                                    = $filebeats::params::inputs,
  $service_bootstrapped                      = $filebeats::params::service_bootstrapped,
  $service_state                             = $filebeats::params::service_state,
) inherits ::filebeats::params {

  include ::elastic_stack::repo
  include ::filebeats::package

  class {'::filebeats::service':
    service_bootstrapped => $service_bootstrapped,
    service_state        => $service_state,
  }

  class{'::filebeats::config':
    elasticsearch_hosts                       => $elasticsearch_hosts,
    elasticsearch_index                       => $elasticsearch_index,
    elasticsearch_password                    => $elasticsearch_password,
    elasticsearch_protocol                    => $elasticsearch_protocol,
    elasticsearch_ssl_certificate             => $elasticsearch_ssl_certificate,
    elasticsearch_ssl_certificate_authorities => $elasticsearch_ssl_certificate_authorities,
    elasticsearch_ssl_certificate_key         => $elasticsearch_ssl_certificate_key,
    elasticsearch_template_enabled            => $elasticsearch_template_enabled,
    elasticsearch_template_name               => $elasticsearch_template_name,
    elasticsearch_template_overwrite          => $elasticsearch_template_overwrite,
    elasticsearch_template_path               => $elasticsearch_template_path,
    elasticsearch_username                    => $elasticsearch_username,
    export_log_paths                          => $export_log_paths,
    kibana_url                                => $kibana_url,
    log_settings                              => $log_settings,
    logstash_hosts                            => $logstash_hosts,
    logstash_bulk_max_size                    => $logstash_bulk_max_size,
    logstash_index                            => $logstash_index,
    logstash_loadbalance                      => $logstash_loadbalance,
    logstash_ssl_certificate                  => $logstash_ssl_certificate,
    logstash_ssl_certificate_authorities      => $logstash_ssl_certificate_authorities,
    logstash_ssl_certificate_key              => $logstash_ssl_certificate_key,
    logstash_ttl                              => $logstash_ttl,
    logstash_worker                           => $logstash_worker,
    modules                                   => $modules,
    modules_conf_dir                          => $modules_conf_dir,
    inputs                                    => $inputs,
    ilm_check_exits                           => $ilm_check_exits,
    ilm_enabled                               => $ilm_enabled,
    ilm_overwrite                             => $ilm_overwrite,
    ilm_pattern                               => $ilm_pattern,
    ilm_policy_file                           => $ilm_policy_file,
    ilm_policy_name                           => $ilm_policy_name,
    ilm_rollover_alias                        => $ilm_rollover_alias,
  }

  Class['::filebeats::params']-> Class['::filebeats::config']
  Class['::filebeats::config']-> Class['::filebeats::service']
}
