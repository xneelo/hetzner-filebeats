# Basic filebeat installation service declaration

class filebeats::service (
  $service_bootstrapped,
  $service_state,
) {
  service {'filebeat':
    ensure  => $service_state,
    enable  => $service_bootstrapped,
    require => Package['filebeat'],
  }
}
