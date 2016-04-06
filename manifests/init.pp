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
#*`log_settings`
# A puppet Hash containing log level ('debug', 'warning', 'error' or 'critical'),
#  to_syslog(true/false), path('/var/log/filebeat'), keepfiles(7), rotateeverybytes(10485760), name(filebeats.log)
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
  $shield_username             = $filebeats::params::shield_username,
  $shield_password             = $filebeats::params::shield_password,
  $elasticsearch_proxy_host    = $filebeats::params::elasticsearch_proxy_host,
  $elasticsearch_protocol      = $filebeats::params::elasticsearch_protocol,
  $tls_certificate_authorities = $filebeats::params::tls_certificate_authorities,
  $tls_certificate             = $filebeats::params::tls_certificate,
  $tls_certificate_key         = $filebeats::params::tls_certificate_key,
  $log_settings                = {},
) inherits ::filebeats::params {

  include ::filebeats::package
  include ::filebeats::service

  class{'::filebeats::config':
    export_log_paths            => $export_log_paths,
    shield_username             => $shield_username,
    shield_password             => $shield_password,
    elasticsearch_proxy_host    => $elasticsearch_proxy_host,
    elasticsearch_protocol      => $elasticsearch_protocol,
    tls_certificate_authorities => $tls_certificate_authorities,
    tls_certificate             => $tls_certificate,
    tls_certificate_key         => $tls_certificate_key,
    log_settings                => $log_settings,
  }
  Class['::filebeats::params']-> Class['::filebeats::config']
}
