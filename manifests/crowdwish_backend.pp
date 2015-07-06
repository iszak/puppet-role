class role::crowdwish_backend (
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
    $home_path    = "/home/${user}"
    $project_path = "${home_path}/${repo_path}"

    include ::profile::base
    include ::profile::apache
    include ::profile::php
    include ::profile::postgresql

    class { 'apache::mod::rewrite':
        require => Class['profile::php']
    }

    project::zf2 { 'crowdwish_backend':
        require           => [
            Package['php5-curl'],
            Package['php5-intl'],
            Package['php5-pgsql']
        ],

        user              => $user,
        owner             => $owner,
        group             => $group,

        repo_path         => $repo_path,
        repo_source       => $repo_source,

        web_path          => $web_path,
        web_host          => $web_host,

        composer_path     => 'web',

        database_name     => $database_name,
        database_username => $database_username,
        database_password => $database_password,

        ssh_key           => $ssh_key,
        ssh_key_path      => $ssh_key_path,
        ssh_config        => $ssh_config,
        ssh_known_hosts   => $ssh_known_hosts,

        environment       => $environment
    }

    exec { 'crowdwish_backend_domain':
        require => Project::Zf2['crowdwish_backend'],
        command => "/bin/sed -i 's/example\\.com/${web_host}/' *local.php",
        cwd     => "${project_path}/web/config/autoload"
    }

    package { [
        'php5-curl',
        'php5-intl',
        'php5-pgsql'
    ]:
        ensure => latest
    }
}
