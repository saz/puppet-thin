# Class: thin
#
# This module manages thin
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class thin(
  $ensure = 'present',
  $autoupgrade = false,
  $package = $thin::params::package,
  $config_dir = $thin::params::config_dir,
  $config_dir_purge = $thin::params::config_dir_purge,
  $config_dir_recurse = $thin::params::config_dir_recurse,
  $service_ensure = $thin::params::service_ensure,
  $service = $thin::params::service,
  $service_enable = $thin::params::service_enable,
  $service_hasstatus = $thin::params::service_hasstatus,
  $service_hasrestart = $thin::params::service_hasrestart
) inherits thin::params {

  validate_bool(
    $autoupgrade,
    $config_dir_purge,
    $config_dir_recurse,
    $service_enable,
    $service_hasstatus,
    $service_hasrestart
  )

  validate_string(
    $package,
    $config_dir,
    $service
  )

  case $ensure {
    present: {
      if $autoupgrade == true {
        $package_ensure = 'latest'
      } else {
        $package_ensure = 'present'
      }

      case $service_ensure {
        running, stopped: {
          $service_ensure_real = $service_ensure
        }
        default: {
          fail("service_ensure parameter must be running or stopped, not ${service_ensure}")
        }
      }

      $file_ensure = 'file'
      $dir_ensure = 'directory'
    }
    absent: {
      $package_ensure = 'absent'
      $service_ensure_real = 'stopped'
      $file_ensure = 'absent'
      $dir_ensure = 'absent'
    }
    default: {
      fail("ensure parameter must be present or absent, not ${ensure}")
    }
  }

  package { $package:
    ensure => $package_ensure,
  }

  file { $config_dir:
    ensure  => $dir_ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    purge   => $config_dir_purge,
    recurse => $config_dir_recurse,
    force   => true,
    require => Package[$package],
    notify  => Service[$service],
  }
}
