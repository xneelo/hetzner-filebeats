# Filebeats

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with filebeats](#setup)
    * [Setup requirements](#setup-requirements)
    * [Beginning with filebeats](#beginning-with-filebeats)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

Very simple puppet module to install and configure elastic search file beats

## Setup

puppet module install hetzner-filebeats

### Setup Requirements

Puppet labs APT module
  version 2.3.0 >=

Puppet labs STDLIB module
  version 4.6.0 >= 5.0.0

### Beginning with filebeats

Use puppet module install function to install module and simply include it from your enc/profile/role/site.pp.

## Usage

The module can be called with the following parameters:

*`export_log_paths`

An array of Strings that specifies which logs the filebeats application must export.

*`prospectors` OPTIONAL

An array of Hashes that specifies which groups of prospectors log entries the filebeats application must export.
This value should be used if you wish to have more than one prospector.

*`shield_username`

The username filebeats should use to authenticate should your cluster make use of shield

*`shield_password`

The password filebeats should use to authenticate should your cluster make use of shield

*`elasticsearch_proxy_host`

A string containing the hostname of your proxy host used for load balancing your cluster.
If left empty it will default to exporting logs to your local host on port 9200.

*`elasticsearch_protocol`

A string containing the protocol used by filebeats, defaults to http. 

*`use_ssl`

Boolean option to enable SSL for output

*`ssl_certificate_authorities`

An array of Strings that specifies paths to Certificate authority files.

*`ssl_certificate`

A String that specifies a path to your hosts certificate to use when connecting to elasticsearch.

*`ssl_certificate_key`

A String that specifies a path to your hosts certificate key to use when connecting to elasticsearch.

*`log_settings`

A puppet Hash containing log level ('debug', 'warning', 'error' or 'critical'), to_syslog(true/false), path('/var/log/filebeat'), keepfiles(7), rotateeverybytes(10485760), name(filebeats.log)

*`service_bootstrapped`

A boolean to turn on or off the filebeat service at boot ('false'/'true'), defaults to 'true'

*`service_state`

A string to describe the state of the filebeats service ('stopped'/'running'), defaults to 'running'

*`loadbalance`

A boolean to turn on or off load balancing for logstash outputs, defulats to false.

*`logstash_hosts`

An array of strings that specifies remote hosts to use for logstash outputs, e.g ['localhost:5044']

*`logstash_index`

A string that specifies the index to use for the logstash output, defaults to '[filebeat-]YYYY.MM.DD' as per the package.

*`elasticsearch_index`

A string that specifies the index to use for the elasticsearch output, defaults to '[filebeat-]YYYY.MM.DD' as per the package.

## Example

Auth.log being exported with only shield login details specified.

```
   class { 'filebeats':
     export_log_paths         => ['/var/log/auth.log'],
     shield_username          => 'host',
     shield_password          => 'secret',
     elasticsearch_proxy_host => 'elasticsearchproxy.myserver.com',
   }
```

Multiple prospectors with multiple log files being exported.

```
   class { 'filebeats':
     prospectors              => [{ 'input_type'    => 'log',
                                    'doc_type'      => 'log',
                                    'paths'         => ['/var/log/auth.log'],
                                    'include_lines' => "['sshd','passwd','vigr']",
                                  },
                                  { 'input_type'    => 'log',
                                    'doc_type'      => 'apache',
                                    'paths'         => ['/var/log/apache2/access.log', '/var/log/apache2/error.log'],
                                    'fields'        => {'level' => 'debug', 'review' => 1},
                                    'exclude_lines' => "['warning'']",
                                  }
                                 ]
     shield_username          => 'host',
     shield_password          => 'secret',
     elasticsearch_proxy_host => 'elasticsearchproxy.myserver.com',
   }
```

## Hiera data example

```
filebeats::prospectors:
  - input_type: 'log'
    paths:
      - '/var/log/auth.log'
    doc_type: 'auth'
    include_lines: ['sshd','passwd','vigr']
  - input_type: 'log'
    paths:
      - '/var/log/my_app.log'
    doc_type: 'my_app'
    exclude_lines: ['warning']
  - input_type: 'log'
    paths:
      - '/var/log/security.log'
    doc_type: 'security'
    fields:
      level: 'debug'
      review: 1
  - input_type: 'log'
    paths:
      - '/var/log/app.json'
    tags:  ['json']
    json_keys_under_root: true
    json_overwrite_keys: true
    json_add_error_key: true
    json_message_key: 'log'
```


## Reference

* `Package`

Configures the apt resrouce for filebeats.

* `Config`

Configures the filebeats.yml file.

* `Service`

Ensures the service is running.

* `Params`

Specifies defaults for the installation and configuration

## Limitations

Does not support all options available to filebeats configuration.

## Development

All pull requests are welcome. This module was just created for our use and functionality will be added as we require it.
