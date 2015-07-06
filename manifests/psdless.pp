class role::psdless (
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
    include ::profile::base
    include ::profile::apache
    include ::profile::node

    project::static { 'psdless':
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
            require   => [
                Class['::profile::node'],
            ],
            provider => npm
        }
    }
}
