class role::crowdwish_client (
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

    project::static { 'crowdwish_client':
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
}
