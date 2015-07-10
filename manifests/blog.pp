class role::blog (
    $user,
    $owner,
    $group,

    $repo_path,
    $repo_source,

    $web_path        = undef,
    $web_host ,

    $ssh_key         = undef,
    $ssh_key_path    = undef,
    $ssh_config      = '',
    $ssh_known_hosts = [],

    $environment,
) {
    include profile::base
    include profile::apache
    include profile::ruby

    $project_path = "/home/${user}/${repo_path}"

    project::ruby { 'blog':
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
