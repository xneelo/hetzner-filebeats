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
  $export_log_paths    = $::filebeats::params::export_log_paths,
  $shield_username     = $::filebeats::params::shield_username,
  $shield_password     = $::filebeats::params::shield_password,
  $elasticsearch_proxy_host = $::filebeats::params::elasticsearch_proxy_host,
){
  include ::filebeats::package

  anchor {'filebeats_first':} -> Class['::filebeats::package']->
Class['::filebeats::service']
  -> Class{'::filebeats::config':
    export_log_paths         => $export_log_paths,
    shield_username          => $shield_username,
    shield_password          => $shield_password,
    elasticsearch_proxy_host => $elasticsearch_proxy_host,
  }-> anchor {'filebeats_last':}
}
