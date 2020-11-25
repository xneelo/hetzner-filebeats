## [2.1.0](https://github.com/xneelo/hetzner-filebeats/tree/2.1.0) (2020-11-25)

Support setting filebeat ilm
- Filebeat 7.0 sets ilm on by default so we need to be able to configure this

## [2.0.1](https://github.com/xneelo/hetzner-filebeats/tree/2.0.1) (2020-11-20)

Minor tweak to enable/disable module
- Only attempt to enable if it is disabled, only disable if it is enabled

## [2.0.0](https://github.com/xneelo/hetzner-filebeats/tree/2.0.0) (2020-11-03)

### [Major version change 6.x => 7.x](https://www.elastic.co/guide/en/beats/libbeat/7.9/breaking-changes-7.0.html#breaking-changes-7.0)

## [1.0.4](https://github.com/xneelo/hetzner-filebeats/tree/1.0.4) (2019-12-09)

Ensure Apt update runs before package installation
- Credit to Thodoris Sotiropoulos - theosotr

## 2019-06-28 - Release 1.0.3
### Summary

NFR: Fix README format

## 2019-06-27 - Release 1.0.2
### Summary

Add support for the following config options to logstash output
* ttl
* bulk_max_size

## 2019-04-25 - Release 1.0.0
### Summary

Update input type setting in filebeats configuration to conform to [6.X syntax](https://www.elastic.co/guide/en/beats/libbeat/6.2/breaking-changes-6.0.html#breaking-changes-types)

## 2018-08-16 - Release 0.3.0
### Summary

Update both logstash output and elasticsearch output for filebeat 5.X syntax
* Rename params to reflect which filebeat output they affect
* Typecast all params
* Expand elasticsearch output support with templates and ssl
* Add support for prospector fields
*   tags
*   Support JSON messages with the following options
*     json.keys_under_root
*     json.add_error_key
*     json.message_key
*     json.add_error_key
*     Credit to https://github.com/hundredacres

## 2017-09-17 - Release 0.2.5
### Summary

Remove unintended blank line in filebeats.yml

## 2017-06-05 - Release 0.2.4
### Summary

Add exclude_line config option

## 2017-06-05 - Release 0.2.3
### Summary

Add include_line config option

## 2017-02-03 - Release 0.2.2
### Summary

Add bootstrapping of filebeat service

## 2017-02-03 - Release 0.2.1
### Summary

Support puppetlabs apt module 2.3
* Bump dependency on puppetlabs apt

## 2017-02-02 - Release 0.1.6
### Summary

Add support for prospector fields
* Added new prospector option, fields
* Thanks for the contribution @belskiiartem

## 2015-04-13 - Release 0.1.5
### Summary

Adding logstash output
* Added new parameters for logstash output
* Added param to specify index to ship for both elasticsearch and logstash
* Added service_state param to allow for overriding
* Added loadbalancing param for logstash output

## 2015-04-08 - Release 0.1.4
### Summary

Fix documentation issues
* Minor indetation in documentation

## 2015-04-08 - Release 0.1.3
### Summary

Fix documentation issues
* Fix code examples in README, still trying to get a hang of this

## 2015-04-08 - Release 0.1.2
### Summary

Fix documentation issues
* Fix code examples in README

## 2015-04-07 - Release 0.1.1
### Summary

Minor update to include multiple prospectors
* This update allows for an array of hashes to configure multiple prospectors
* This includes setting of input_type and document type in each hash

## 2015-04-06 - Release 0.1.0
### Summary

First major release with tested (on our environment) log exporting
* Added logging options for filebeats

## 2015-04-01 - Release 0.0.13
### Summary

* Minor bug fixes
* Added TLS/SSL support
* Added protocol option

## 2015-03-24 - Release 0.0.9
### Summary

First working release of basic puppet filebeats module
* This version only included very basic funcionality for installing and configuring file beats on Debian Wheezy
* Fixed minor resource ordering issues
* Fixed some typos in the filebeat template
* Fixed service notify errors
* Added shield username and password options
