class role::blog (
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
    include profile::ruby

    $project_path = "/home/${user}/${repo_path}"

    project::ruby { 'blog':
        user        => $user,
        owner       => $owner,
        group       => $group,

        repo_path   => $repo_path,
        repo_source => $repo_source,

        web_path    => $web_path,
        web_host    => $web_host,

        ssh_key     => $ssh_key
    }

    ruby::rake { 'blog_generate':
        require => [
            Project::Ruby['blog']
        ],
        task      => 'site:generate',
        rails_env => 'production',
        bundle    => 'true',
        user      => $user,
        group     => $group,
        cwd       => $project_path
    }
}
