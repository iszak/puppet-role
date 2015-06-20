class role::uploadir_api (
    $user              = undef,
    $owner             = undef,
    $group             = undef,

    $database_name     = undef,
    $database_username = undef,
    $database_password = undef,

    $repo_path         = undef,
    $repo_source       = undef,

    $web_path          = undef,
    $web_host          = undef,

    $ssh_key           = undef,
    $ssh_key_path      = undef,
    $ssh_config        = '',
    $ssh_known_hosts   = [],

    $environment       = undef
) {
    include profile::base
    include profile::apache
    include profile::ruby
    include profile::postgresql

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

        user              => $user,
        owner             => $owner,
        group             => $group,

        repo_path         => $repo_path,
        repo_source       => $repo_source,

        web_path          => $web_path,
        web_host          => $web_host,

        database_name     => $database_name,
        database_username => $database_username,
        database_password => $database_password,

        ssh_key           => $ssh_key,
        ssh_key_path      => $ssh_key_path,
        ssh_config        => $ssh_config,
        ssh_known_hosts   => $ssh_known_hosts,

        environment       => $environment,
        capistrano        => $capistrano,

        custom_fragment   => "
XSendFile On\n
XSendFilePath ${shared_path}/uploads/\n
XSendFilePath ${shared_path}/tmp/downloads/\n
        "
    }

    exec { [
        "/bin/rm -rf ${home_path}/current/uploads",
    ]:
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

    exec { [
        "/bin/ln --symbolic --force ${shared_path}/uploads /home/uploadir/current/uploads",
    ]:
        require => [
            Exec["/bin/rm -rf ${home_path}/current/uploads"],
            File["${shared_path}/uploads"],
        ],
        user    => $user,
        group   => $group,
        unless  => "/usr/bin/test -L ${home_path}/current/uploads"
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
