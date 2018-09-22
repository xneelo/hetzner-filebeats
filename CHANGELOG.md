##2018-08-16 - Release 0.2.6
###Summary

Add support for prospector fields
* tags
* Support JSON messages with the following options
*   json.keys_under_root
*   json.add_error_key
*   json.message_key
*   json.add_error_key

Credit to https://github.com/hundredacres

##2017-09-17 - Release 0.2.5
###Summary

Remove unintended blank line in filebeats.yml

##2017-06-05 - Release 0.2.4
###Summary

Add exclude_line config option

##2017-06-05 - Release 0.2.3
###Summary

Add include_line config option

##2017-02-03 - Release 0.2.2
###Summary

Add bootstrapping of filebeat service

##2017-02-03 - Release 0.2.1
###Summary

Support puppetlabs apt module 2.3
* Bump dependency on puppetlabs apt

##2017-02-02 - Release 0.1.6
###Summary

Add support for prospector fields
* Added new prospector option, fields
* Thanks for the contribution @belskiiartem

##2015-04-13 - Release 0.1.5
###Summary

Adding logstash output
* Added new parameters for logstash output
* Added param to specify index to ship for both elasticsearch and logstash
* Added service_state param to allow for overriding
* Added loadbalancing param for logstash output

##2015-04-08 - Release 0.1.4
###Summary

Fix documentation issues
* Minor indetation in documentation

##2015-04-08 - Release 0.1.3
###Summary

Fix documentation issues
* Fix code examples in README, still trying to get a hang of this

##2015-04-08 - Release 0.1.2
###Summary

Fix documentation issues
* Fix code examples in README

##2015-04-07 - Release 0.1.1
###Summary

Minor update to include multiple prospectors
* This update allows for an array of hashes to configure multiple prospectors
* This includes setting of input_type and document type in each hash

##2015-04-06 - Release 0.1.0
###Summary

First major release with tested (on our environment) log exporting
* Added logging options for filebeats

##2015-04-01 - Release 0.0.13
###Summary

* Minor bug fixes
* Added TLS/SSL support
* Added protocol option

##2015-03-24 - Release 0.0.9
###Summary

First working release of basic puppet filebeats module
* This version only included very basic funcionality for installing and configuring file beats on Debian Wheezy
* Fixed minor resource ordering issues
* Fixed some typos in the filebeat template
* Fixed service notify errors
* Added shield username and password options
