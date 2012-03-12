class thin::params {
  case $::operatingsystem {
    ubuntu, debian: {
      $package = 'thin'
      $log_dir = '/var/log/thin/'
      $config_dir = '/etc/thin/'
      $config_dir_purge = true
      $config_dir_recurse = true
      $service_ensure = 'running'
      $service = 'thin'
      $service_enable = true
      $service_hasstatus = false
      $service_hasrestart = true
    }
    default: {
      fail("Unsupported platform: ${::operatingsystem}")
    }
  }
}
