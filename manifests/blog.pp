class role::blog (
    $user,
    $owner,
    $group,

    $repo_path,
    $repo_source,

    $web_host,

    $environment,

    $ssh_key         = undef,
    $ssh_key_path    = undef,
    $ssh_config      = undef,
    $ssh_known_hosts = undef,
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

        web_path        => '_site/',
        web_host        => $web_host,

        ssh_key         => $ssh_key,
        ssh_key_path    => $ssh_key_path,
        ssh_config      => $ssh_config,
        ssh_known_hosts => $ssh_known_hosts,

        environment     => $environment,
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
        cwd       => $project_path,
        onlyif    => "/usr/bin/test $(find ${project_path} -not -iwholename '*/vendor*' -not -iwholename '*/.git*' -not -iwholename '*/_site*' -mtime -1 -print -quit)"
    }
}
