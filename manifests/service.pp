# Basic filebeat installation service declaration

class filebeats::service (
  $service_bootstrapped,
  $service_state,
) {
  service {'filebeat':
    enable  => $service_bootstrapped,
    ensure  => $service_state,
    require => Package['filebeat'],
  }
}
