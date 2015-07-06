class role::phoenix_client (
    $user            = undef,
    $owner           = undef,
    $group           = undef,

    $repo_path       = undef,
    $repo_source     = undef,

    $web_path        = undef,
    $web_host        = undef,

    $ssh_key         = undef,
    $ssh_key_path    = undef,
    $ssh_config      = '',
    $ssh_known_hosts = [],
) {
    include profile::base
    include profile::apache

    project::static { 'phoenix_client':
        user            => $user,
        owner           => $owner,
        group           => $group,

        repo_path       => $repo_path,
        repo_source     => $repo_source,

        web_path        => $web_path,
        web_host        => $web_host,

        ssh_key         => $ssh_key,
        ssh_key_path    => $ssh_key_path,
        ssh_config      => $ssh_config,
        ssh_known_hosts => $ssh_known_hosts,

        npm_install     => true
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
