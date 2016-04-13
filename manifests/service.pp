# Basic filebeat installation service declaration

class filebeats::service (
  $service_state,
) {
  service {'filebeat':
    ensure  => $service_state,
    require => Package['filebeat'],
  }
}
