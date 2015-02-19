class role::1001_beers_website (
    $user        = undef,
    $owner       = undef,
    $group       = undef,

    $repo_path   = undef,
    $repo_source = undef,

    $web_path    = undef,
    $web_host    = undef,

    $ssh_key     = undef
) {
    include profile::base
    include profile::apache

    project::static { '1001_beers_website':
        user        => $user,
        owner       => $owner,
        group       => $group,

        repo_path   => $repo_path,
        repo_source => $repo_source,

        web_path    => $web_path,
        web_host    => $web_host,

        ssh_key     => $ssh_key
    }

    if (!defined(Package['grunt-cli'])) {
        package { 'grunt-cli':
            ensure   => present,
            require  => [
                Class[nodejs],
                Package[npm],
            ],
            provider => npm
        }
    }

    if (!defined(Package['bower'])) {
        package { 'bower':
            ensure   => present,
            require  => [
                Class[nodejs],
                Package[npm],
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
