# Basic filebeat installation service declaration

class filebeats::service {
  service {'filebeat':
    ensure  => running,
    require => Package['filebeat'],
  }
}
