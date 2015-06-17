class role::1001_beers_api (
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

    $environment       = undef,
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
        require           => [
            Class[postgresql::lib::devel],
            Package['libsqlite3-dev']
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
        ssh_known_hosts   => $ssh_known_hosts,
        ssh_config        => $ssh_config,

        environment       => $environment,
        capistrano        => $capistrano,
    }

    if (!defined(Package['libsqlite3-dev'])) {
        package { 'libsqlite3-dev':
            ensure => latest
        }
    }
}
