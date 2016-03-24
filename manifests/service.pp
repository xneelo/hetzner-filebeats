# Basic filebeat installation service declaration

class filebeats::service {
  service {'filebeats':
    ensure  => running,
    require => Package['filebeats'],
  }
}
