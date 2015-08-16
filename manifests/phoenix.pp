class role::phoenix (
  $user,
  $owner,
  $group,

  $database_name,
  $database_username,
  $database_password,

  $repo_path,

  $web_host,

  $environment,

  $client_ssh_private_keys     = {},
  $client_ssh_private_key_path = undef,

  $server_ssh_private_keys     = {},
  $server_ssh_private_key_path = undef,

  $ssh_config                  = '',
  $ssh_known_hosts             = {},

  $ssh_authorized_keys         = {},
) {
  class { 'role::phoenix_server':
    user                 => $user,
    owner                => $owner,
    group                => $group,

    repo_path            => "${repo_path}/server",

    web_host             => "api.${web_host}",

    database_name        => $database_name,
    database_username    => $database_username,
    database_password    => $database_password,

    ssh_private_keys     => $server_ssh_private_keys,
    ssh_private_key_path => $server_ssh_private_key_path,

    ssh_config           => $ssh_config,
    ssh_known_hosts      => $ssh_known_hosts,

    ssh_authorized_keys  => $ssh_authorized_keys,

    environment          => $environment
  }

  class { 'role::phoenix_client':
    user                 => $user,
    owner                => $owner,
    group                => $group,

    repo_path            => "${repo_path}/client",

    web_host             => $web_host,

    ssh_private_keys     => $client_ssh_private_keys,
    ssh_private_key_path => $client_ssh_private_key_path,

    ssh_authorized_keys  => $ssh_authorized_keys,

    environment          => $environment,
  }
}
