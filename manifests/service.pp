# Basic filebeat installation service declaration
# @param service_bootstrapped Whether the service should be enabled at boot
# @param service_state The desired state of the service
#
class filebeats::service (
  Boolean $service_bootstrapped,
  Enum['running', 'stopped'] $service_state,
) {
  service { 'filebeat':
    ensure  => $service_state,
    enable  => $service_bootstrapped,
    require => Package['filebeat'],
  }
}
