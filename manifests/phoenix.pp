class role::phoenix (
    $user,
    $owner,
    $group,

    $database_name,
    $database_username,
    $database_password,

    $repo_path,

    $web_host,

    $environment,

    $client_ssh_private_keys     = {},
    $client_ssh_private_key_path = undef,

    $server_ssh_private_keys     = {},
    $server_ssh_private_key_path = undef,

    $ssh_config                  = '',
    $ssh_known_hosts             = {},

    $ssh_authorized_keys         = {},
) {
    include profile::base
    include profile::apache
    include profile::node

    project::node { 'phoenix_server':
        user                 => $user,
        owner                => $owner,
        group                => $group,

        repo_path            => "${repo_path}/server",
        repo_source          => 'git@bitbucket.org:iszak/phoenix-server.git',

        web_path             => 'public/',
        web_host             => "api.${web_host}",

        ssh_private_keys     => $server_ssh_private_keys,
        ssh_private_key_path => $server_ssh_private_key_path,

        ssh_config           => $ssh_config,
        ssh_known_hosts      => $ssh_known_hosts,

        ssh_authorized_keys  => $ssh_authorized_keys,

        environment          => $environment
    }

    project::static { 'phoenix_client':
        user                 => $user,
        owner                => $owner,
        group                => $group,

        repo_path            => "${repo_path}/client",
        repo_source          => 'git@bitbucket.org:iszak/phoenix-client.git',

        web_host             => $web_host,

        ssh_private_keys     => $client_ssh_private_keys,
        ssh_private_key_path => $client_ssh_private_key_path,

        ssh_config           => $ssh_config,
        ssh_known_hosts      => $ssh_known_hosts,

        ssh_authorized_keys  => $ssh_authorized_keys,

        npm_install          => true,

        environment          => $environment,
    }


    if (!defined(Package['grunt-cli'])) {
        package { 'grunt-cli':
            ensure   => present,
            require  => [
                Class[nodejs],
            ],
            provider => npm
        }
    }


    if (!defined(Package['compass'])) {
        package { 'compass':
            ensure   => present,
            require  => Class[ruby::dev],
            provider => gem
        }
    }
}
