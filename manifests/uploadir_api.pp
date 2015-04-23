class role::uploadir_api (
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

    $environment       = undef
) {
    include profile::base
    include profile::apache
    include profile::ruby
    include profile::postgresql

    include apache::mod::xsendfile

    $home_path    = "/home/${user}"
    $project_path = "${home_path}/${repo_path}"

    project::rails { 'uploadir_api':
        require           => [
            Class[postgresql::lib::devel],
            Package['libmagic-dev'],
            Package['libsqlite3-dev'],
        ],

        user              => $user,
        owner             => $owner,
        group             => $group,

        repo_path         => $repo_path,
        repo_source       => $repo_source,

        web_path          => $web_path,
        web_host          => $web_host,

        database_name     => $database_name,
        database_username => $database_username,
        database_password => $database_password,

        ssh_key           => $ssh_key,

        environment       => $environment,

        custom_fragment   => "
XSendFile On\n
XSendFilePath ${project_path}/uploads/\n
XSendFilePath ${project_path}/tmp/downloads/\n
        "
    }

    if (!defined(Package['libmagic-dev'])) {
        package { 'libmagic-dev':
            ensure => latest
        }
    }

    if (!defined(Package['libsqlite3-dev'])) {
        package { 'libsqlite3-dev':
            ensure => latest
        }
    }
}
