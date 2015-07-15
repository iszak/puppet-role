class role::uploadir_api (
    $user,
    $owner,
    $group,

    $database_name,
    $database_username,
    $database_password,

    $repo_path,
    $repo_source,

    $web_host,

    $environment,

    $ssh_private_keys     = {},
    $ssh_private_key_path = undef,

    $ssh_config           = '',
    $ssh_known_hosts      = {},

    $ssh_authorized_keys  = {},
) {
    include ::profile::base
    include ::profile::apache
    include ::profile::ruby
    include ::profile::postgresql

    include apache::mod::xsendfile

    $home_path    = "/home/${user}"
    $project_path = "${home_path}/${repo_path}"

    if ($environment == 'production') {
        $capistrano = true
        $shared_path = "${home_path}/shared"
    } else {
        $capistrano = false
        $shared_path = $project_path
    }

    project::rails { $title:
        require           => [
            Class[postgresql::lib::devel],
            Package['libmagic-dev'],
            Package['libsqlite3-dev'],
        ],

        user                 => $user,
        owner                => $owner,
        group                => $group,

        repo_path            => $repo_path,
        repo_source          => $repo_source,

        web_path             => 'public/',
        web_host             => $web_host,

        database_type        => 'postgresql',
        database_name        => $database_name,
        database_username    => $database_username,
        database_password    => $database_password,

        ssh_private_keys     => $ssh_private_keys,
        ssh_private_key_path => $ssh_private_key_path,

        ssh_config           => $ssh_config,
        ssh_known_hosts      => $ssh_known_hosts,

        ssh_authorized_keys  => $ssh_authorized_keys,

        environment          => $environment,
        capistrano           => $capistrano,

        custom_fragment      => "
XSendFile On\n
XSendFilePath ${shared_path}/uploads/\n
XSendFilePath ${shared_path}/tmp/downloads/\n
        "
    }

    if ($capistrano == true) {
      exec { "/bin/rm -rf ${home_path}/current/uploads":
          require => Project::Rails[$title],
          unless  => "/usr/bin/test -L ${home_path}/current/uploads"
      }

      file { [
          "${shared_path}/uploads",
          "${shared_path}/tmp/downloads",
      ]:
          ensure  => directory,
          require => Project::Rails[$title],
          owner   => $owner,
          group   => $group,
      }

      exec { "/bin/ln --symbolic --force ${shared_path}/uploads /home/uploadir/current/uploads":
          require => [
              Exec["/bin/rm -rf ${home_path}/current/uploads"],
              File["${shared_path}/uploads"],
          ],
          user    => $user,
          group   => $group,
          unless  => "/usr/bin/test -L ${home_path}/current/uploads"
      }
    }

    if (!defined(Package['libmagic-dev'])) {
        package { 'libmagic-dev':
            ensure => latest
        }
    }

    if (!defined(Package['libsqlite3-dev'])) {
        package { 'libsqlite3-dev':
            ensure => latest
        }
    }
}
