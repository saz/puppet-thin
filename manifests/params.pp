class thin::params {
  case $::operatingsystem {
    ubuntu, debian: {
      $package = 'thin1.8'
      $log_dir = '/var/log/thin/'
      $config_dir = '/etc/thin1.8/'
      $config_dir_purge = true
      $config_dir_recurse = true
      $service_ensure = 'running'
      $service = 'thin1.8'
      $service_enable = true
      $service_hasstatus = false
      $service_hasrestart = true
    }
    default: {
      fail("Unsupported platform: ${::operatingsystem}")
    }
  }
}
