class role::beers_website (
    $user,
    $owner,
    $group,

    $repo_path,

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

  project::static { '1001_beers_website':
    user                 => $user,
    owner                => $owner,
    group                => $group,

    repo_path            => $repo_path,
    repo_source          => 'https://github.com/iszak/1001-beers-website.git',
    repo_revision        => $repo_revision,

    web_host             => $web_host,

    ssh_private_keys     => $ssh_private_keys,
    ssh_private_key_path => $ssh_private_key_path,

    ssh_config           => $ssh_config,
    ssh_known_hosts      => $ssh_known_hosts,

    ssh_authorized_keys  => $ssh_authorized_keys,

    environment          => $environment,
  }

  if (!defined(Package['grunt-cli'])) {
    package { 'grunt-cli':
      ensure   => present,
      require  => [
          Class[nodejs],
      ],
      provider => npm
    }
  }

  if (!defined(Package['bower'])) {
    package { 'bower':
      ensure   => present,
      require  => [
          Class[nodejs],
      ],
      provider => npm
    }
  }

  if (!defined(Package['compass'])) {
    package { 'compass':
      ensure   => present,
      require  => Class[ruby::dev],
      provider => gem
    }
  }
}
