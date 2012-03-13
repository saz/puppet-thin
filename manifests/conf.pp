define thin::conf(
  $chdir,
  $user,
  $group,
  $timeout = 30,
  $rails_environment = 'production',
  $log_dir = '/var/log/thin/',
  $pid_dir = '/var/run/thin/',
  $socket_dir = $pid_dir,
  $thin_daemonize = true,
  $servers = $::physicalprocessorcount,
  $max_conns = 1024,
  $max_persistent_conns = 512,
  $config_dir = $thin::params::config_dir,
  $service = $thin::params::service,
  $thin_require = false,
  $thin_require_content = [],
  $additional_lines = []
) {
  include thin::params
  require thin

  validate_bool($daemonize, $thin_require)
  validate_array($additional_lines)

  validate_string(
    $chdir,
    $user,
    $group,
    $environment,
    $log_dir,
    $pid_dir,
    $socket_dir,
    $config_dir,
    $service,
  )

  file { "${config_dir}${name}.yml":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('thin/app-config.yml.erb'),
    notify  => Service[$service],
  }

  if $thin_require == true {
    file { "${config_dir}${name}.rb":
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0640',
      content => template('thin/app-require.rb.erb'),
      notify  => Service[$service],
    }
  }

  if !defined(File[$log_dir]) {
    file { $log_dir:
      ensure => directory,
      owner  => $user,
      group  => $group,
      mode   => '0750',
      force  => true,
      notify => Service[$service],
    }
  }

  if !defined(File[$pid_dir]) {
    file { $pid_dir:
      ensure => directory,
      owner  => 'root',
      group  => $group,
      mode   => '0775',
      force  => true,
      notify => Service[$service],
    }
  }

  if !defined(File[$socket_dir]) {
    file { $socket_dir:
      ensure => directory,
      owner  => 'root',
      group  => $group,
      mode   => '0775',
      force  => true,
      notify => Service[$service],
    }
  }
}
