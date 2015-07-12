class role::crowdwish_backend (
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

    $ssh_key           = undef,
    $ssh_key_path      = undef,
    $ssh_config        = undef,
    $ssh_known_hosts   = undef,
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

        web_path          => 'web/public/',
        web_host          => $web_host,

        composer_path     => 'web',

        database_type     => 'postgresql',
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
        cwd     => "${project_path}/web/config/autoload",
        onlyif  => '/bin/grep example.com *local.php'
    }

    package { [
        'php5-curl',
        'php5-intl',
        'php5-pgsql'
    ]:
        ensure => latest
    }
}
