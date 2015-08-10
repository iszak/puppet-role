class role::crowdwish_client (
    $user,
    $owner,
    $group,

    $repo_path,
    $repo_source,

    $web_host,

    $environment,

    $ssh_private_keys     = {},
    $ssh_private_key_path = undef,

    $ssh_config           = '',
    $ssh_known_hosts      = {},

    $ssh_authorized_keys  = {},
) {
  include profile::base
  include profile::apache

  if ($environment == 'production') {
    $repo_revision = 'production'
  } else {
    $repo_revision = 'master'
  }

  project::static { 'crowdwish_client':
    user                 => $user,
    owner                => $owner,
    group                => $group,

    repo_path            => $repo_path,
    repo_source          => $repo_source,
    repo_revision        => $repo_revision,

    web_host             => $web_host,

    ssh_private_keys     => $ssh_private_keys,
    ssh_private_key_path => $ssh_private_key_path,

    ssh_config           => $ssh_config,
    ssh_known_hosts      => $ssh_known_hosts,

    ssh_authorized_keys  => $ssh_authorized_keys,

    environment          => $environment,
  }
}
