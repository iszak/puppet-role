class role::uploadir (
  $user,
  $owner,
  $group,

  $database_name,
  $database_username,
  $database_password,

  $repo_path,

  $web_host,

  $environment,
  $secrets,

  $api_ssh_private_keys     = {},
  $api_ssh_private_key_path = undef,

  $client_ssh_private_keys     = {},
  $client_ssh_private_key_path = undef,

  $ssh_config                   = '',
  $ssh_known_hosts              = {},

  $ssh_authorized_keys         = {},
) {
  class { 'uploadir_api':
    user                 => $user,
    owner                => $owner,
    group                => $group,

    database_name        => $database_name,
    database_username    => $database_username,
    database_password    => $database_password,

    repo_path            => regsubst("${repo_path}/api", '^/', ''),
 
    web_host             => "api.${web_host}",

    environment          => $environment,

    ssh_private_keys     => $api_ssh_private_keys,
    ssh_private_key_path => $api_ssh_private_key_path,

    ssh_config           => $ssh_config,
    ssh_known_hosts      => $ssh_known_hosts,

    ssh_authorized_keys  => $ssh_authorized_keys,
    secrets              => $secrets,
  }


  class { 'uploadir_client':
    user                 => $user,
    owner                => $owner,
    group                => $group,

    repo_path            => regsubst("${repo_path}/client", '^/', ''),

    web_host             => $web_host,

    environment          => $environment,

    ssh_private_keys     => $client_ssh_private_keys,
    ssh_private_key_path => $client_ssh_private_key_path,

    ssh_config           => $ssh_config,
    ssh_known_hosts      => $ssh_known_hosts,

    ssh_authorized_keys  => $ssh_authorized_keys,
  }
}
