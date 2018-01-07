##
# = class: jetty::install - The installation of jetty's stuff
class jetty::install inherits jetty {
  $_jetty_home             = [$jetty::root, 'jetty'].join('/')
  $_jetty_tmp              = [$_jetty_home, 'tmp'].join('/')
  $_jetty_logs             = [$_jetty_home, 'logs'].join('/')
  $_jetty_run              = [$_jetty_home, 'run'].join('/')
  $_jetty_sh               = [$_jetty_home, 'bin', 'jetty.sh'].join('/')
  $_download_directory     = "jetty-distribution-${jetty::version}"
  $_download_file_name     = "${_download_directory}.${jetty::archive_type}"
  $_tmp_download_file_name = ['/tmp', $_download_file_name].join('/')
  $_download_url           = [$jetty::mirror,
                              'org',
                              'eclipse',
                              'jetty',
                              'jetty-distribution',
                              $jetty::version,
                              $_download_file_name].join('/')
  $_download_url_checksum  = "${_download_url}.${jetty::checksum_type}"

  include '::archive'

  if $jetty::manage_user {
    ensure_resource('group', $::jetty::group, {
      ensure => present,
    })

    ensure_resource('user', $::jetty::user, {
      shell  => '/bin/false',
      system => false,
      home   => $_jetty_tmp,
      gid    => $::jetty::group,
    })
  }

  File {
    owner => $::jetty::user,
    group => $::jetty::group,
    mode  => '0774',
  }

  file { $_jetty_home:
    ensure => link,
    target => "${::jetty::root}/${_download_directory}",
  }
  -> file { "${::jetty::root}/${_download_directory}":
    ensure => directory,
  }
  -> archive { $_tmp_download_file_name:
    ensure          => present,
    source          => $_download_url,
    checksum_url    => $_download_url_checksum,
    checksum_verify => true,
    allow_insecure  => true,
    extract         => true,
    extract_path    => $::jetty::root,
    cleanup         => true,
    creates         => "${::jetty::root}/jetty-installed",
    user            => $::jetty::user,
    group           => $::jetty::group,
    require         => User[$::jetty::user],
  }

  file { $_jetty_run:
    ensure => directory,
    owner  => $::jetty::user,
    group  => $::jetty::group,
  }
  -> file { '/etc/init.d/jetty':
    ensure => link,
    target => $_jetty_sh,
    owner  => 'root',
    group  => 'root',
    mode   => '0750',
  }
  -> file { '/var/log/jetty':
    ensure => link,
    target => $_jetty_logs,
  }
  -> file { '/var/run/jetty':
    ensure => link,
    target => $_jetty_run,
  }
  -> file { $_jetty_tmp:
    ensure => directory,
  }
}
