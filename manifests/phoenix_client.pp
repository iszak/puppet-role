class role::phoenix_client (
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

    project::static { 'phoenix_client':
        user        => $user,
        owner       => $owner,
        group       => $group,

        repo_path   => $repo_path,
        repo_source => $repo_source,

        web_path    => $web_path,
        web_host    => $web_host,

        ssh_key     => $ssh_key,

        npm_install => true
    }
}
