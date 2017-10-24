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
# * `prospectors`
# An array of Hashes that specifies which groups of prospectors log entries the filebeats application must export.
# * `shield_username`
# The username filebeats should use to authenticate should your cluster make use of shield
# * `shield_password`
# The password filebeats should use to authenticate should your cluster make use of shield
# * `elasticsearch_proxy_host`
# A string containing the hostname of your proxy host used for load balancing your cluster.
# If left empty it will default to exporting logs to your local host on port 9200.
# * `elasticsearch_protocol`
# A string containing the protocl used by filebeats to send logs.
# * `tls_certificate_authorities`
# An array of Strings that specifies paths to Certificate authority files.
# * `tls_certificate`
# A String that specifies a path to your hosts certificate to use when connecting to elasticsearch.
# * `tls_certificate_key`
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
# *`elasticsearch_index`
# A string that specifies the index to use for the elasticsearch output, defaults to '[filebeat-]YYYY.MM.DD' as per the package.
#
# Example
# --------
#
# @example
#    class { 'filebeats':
#      export_log_paths         => ['/var/log/auth.log'],
#      shield_username          => 'host',
#      shield_password          => 'secret',
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
  $export_log_paths            = $filebeats::params::export_log_paths,
  $prospectors                 = $filebeats::params::prospectors,
  $json_message_key	       = $filebeats::params::json_message_key,
  $shield_username             = $filebeats::params::shield_username,
  $shield_password             = $filebeats::params::shield_password,
  $elasticsearch_proxy_host    = $filebeats::params::elasticsearch_proxy_host,
  $elasticsearch_protocol      = $filebeats::params::elasticsearch_protocol,
  $tls_certificate_authorities = $filebeats::params::tls_certificate_authorities,
  $tls_certificate             = $filebeats::params::tls_certificate,
  $tls_certificate_key         = $filebeats::params::tls_certificate_key,
  $service_bootstrapped        = $filebeats::params::service_bootstrapped,
  $service_state               = $filebeats::params::service_state,
  $loadbalance                 = $filebeats::params::loadbalance,
  $logstash_hosts              = $filebeats::params::logstash_hosts,
  $log_settings                = {},
  $logstash_index              = $filebeats::params::logstash_index,
  $elasticsearch_index         = $filebeats::params::elasticsearch_index,
) inherits ::filebeats::params {

  include ::filebeats::package

  class {'::filebeats::service':
    service_bootstrapped => $service_bootstrapped,
    service_state        => $service_state,
  }

  class{'::filebeats::config':
    export_log_paths            => $export_log_paths,
    prospectors                 => $prospectors,
    json_message_key		=> $json_message_key,
    shield_username             => $shield_username,
    shield_password             => $shield_password,
    elasticsearch_proxy_host    => $elasticsearch_proxy_host,
    elasticsearch_protocol      => $elasticsearch_protocol,
    tls_certificate_authorities => $tls_certificate_authorities,
    tls_certificate             => $tls_certificate,
    tls_certificate_key         => $tls_certificate_key,
    log_settings                => $log_settings,
    loadbalance                 => $loadbalance,
    logstash_hosts              => $logstash_hosts,
    logstash_index              => $logstash_index,
    elasticsearch_index         => $elasticsearch_index,
  }

  Class['::filebeats::params']-> Class['::filebeats::config']
  Class['::filebeats::config']-> Class['::filebeats::service']
}
