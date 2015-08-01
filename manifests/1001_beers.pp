class role::1001_beers (
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

    $ssh_private_keys     = {},
    $ssh_private_key_path = undef,

    $ssh_config           = '',
    $ssh_known_hosts      = {},

    $ssh_authorized_keys  = {},
) {
  class { '1001_beers_api':
    user                 => $user,
    owner                => $owner,
    group                => $group,

    database_name        => $database_name,
    database_username    => $database_username,
    database_password    => $database_password,

    repo_path            => regsubst("${repo_path}/api", '^/', ''),
    repo_source          => "https://github.com/iszak/1001-beers-api.git",

    web_host             => "api.${web_host}",

    environment          => $environment,

    ssh_private_keys     => $ssh_private_keys,
    ssh_private_key_path => $ssh_private_key_path,

    ssh_config           => $ssh_config,
    ssh_known_hosts      => $ssh_known_hosts,

    ssh_authorized_keys  => $ssh_authorized_keys,
    secrets              => $secrets,
  }


  class { '1001_beers_website':
    user                 => $user,
    owner                => $owner,
    group                => $group,

    repo_path            => regsubst("${repo_path}/website", '^/', ''),
    repo_source          => "https://github.com/iszak/1001-beers-website.git",

    web_host             => $web_host,

    environment          => $environment,

    ssh_private_keys     => $ssh_private_keys,
    ssh_private_key_path => $ssh_private_key_path,

    ssh_config           => $ssh_config,
    ssh_known_hosts      => $ssh_known_hosts,

    ssh_authorized_keys  => $ssh_authorized_keys,
  }
}
