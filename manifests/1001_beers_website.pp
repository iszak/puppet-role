class role::1001_beers_website (
    $user,
    $owner,
    $group,

    $repo_path,
    $repo_source,

    $web_path        = undef,
    $web_host,

    $ssh_key         = undef,
    $ssh_key_path    = undef,
    $ssh_config      = '',
    $ssh_known_hosts = [],

    $environment,
) {
    include profile::base
    include profile::apache

    project::static { '1001_beers_website':
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

    if (!defined(Package['bower'])) {
        package { 'bower':
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
