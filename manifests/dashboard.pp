class role::dashboard (
  $monitor,
  $monitor_backend = undef,
) {
  include profile::base

  validate_bool($monitor)
  validate_string($monitor_backend)

  if $monitor {
    class { '::profile::monitor::agent':
      backend => $monitor_backend,
    }
  }

  class { '::profile::monitor::backend': }
}
