class role::puppetmaster (
  $puppetdb = true
) {
  validate_bool($puppetdb)

  include ::profile::base

  if $puppetdb == true {
    class { '::puppetdb': }
  }
}
