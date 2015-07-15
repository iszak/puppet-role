class role::1001_beers_api (
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
    include profile::base
    include profile::apache
    include profile::ruby
    include profile::postgresql

    if ($environment == 'production') {
        $capistrano = true
    } else {
        $capistrano = false
    }

    project::rails { '1001_beers_api':
        require              => [
            Class[postgresql::lib::devel],
            Package['libsqlite3-dev']
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
    }

    if (!defined(Package['libsqlite3-dev'])) {
        package { 'libsqlite3-dev':
            ensure => latest
        }
    }
}
