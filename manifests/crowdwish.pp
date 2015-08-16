class role::crowdwish (
  $user,
  $owner,
  $group,

  $database_name,
  $database_username,
  $database_password,

  $repo_path,

  $web_host,

  $environment,

  $backend_ssh_private_keys     = {},
  $backend_ssh_private_key_path = undef,

  $client_ssh_private_keys     = {},
  $client_ssh_private_key_path = undef,

  $ssh_config                  = '',
  $ssh_known_hosts             = {},

  $ssh_authorized_keys         = {},
) {
  $home_path    = "/home/${user}"
  $project_path = "${home_path}/${repo_path}"

  class { 'role::crowdwish_backend':
    user                 => $user,
    owner                => $owner,
    group                => $group,

    repo_path            => regsubst("${repo_path}/backend", '^/', ''),

    web_host             => "api.${web_host}",

    database_name        => $database_name,
    database_username    => $database_username,
    database_password    => $database_password,

    ssh_private_keys     => $backend_ssh_private_keys,
    ssh_private_key_path => $backend_ssh_private_key_path,

    ssh_config           => $ssh_config,
    ssh_known_hosts      => $ssh_known_hosts,

    ssh_authorized_keys  => $ssh_authorized_keys,

    environment          => $environment
  }

  class { 'role::crowdwish_client':
    user                 => $user,
    owner                => $owner,
    group                => $group,

    repo_path            => regsubst("${repo_path}/client", '^/', ''),

    web_host             => $web_host,

    ssh_private_keys     => $client_ssh_private_keys,
    ssh_private_key_path => $client_ssh_private_key_path,

    ssh_authorized_keys  => $ssh_authorized_keys,

    environment          => $environment,
  }
}
