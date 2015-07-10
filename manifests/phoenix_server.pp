class role::phoenix_server (
    $user,
    $owner,
    $group,

    $database_name,
    $database_username,
    $database_password,

    $repo_path,
    $repo_source,

    $web_path          = undef,
    $web_host,

    $ssh_key           = undef,
    $ssh_key_path      = undef,
    $ssh_config        = '',
    $ssh_known_hosts   = [],

    $environment,
) {
    include profile::base
    include profile::apache
    include profile::node
    include profile::postgresql

    project::node { 'phoenix_server':
        user              => $user,
        owner             => $owner,
        group             => $group,

        repo_path         => $repo_path,
        repo_source       => $repo_source,

        web_path          => $web_path,
        web_host          => $web_host,

        ssh_key           => $ssh_key,
        ssh_key_path      => $ssh_key_path,
        ssh_config        => $ssh_config,
        ssh_known_hosts   => $ssh_known_hosts,

        environment       => $environment
    }
}
