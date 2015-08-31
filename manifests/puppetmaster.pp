class role::puppetmaster (
  $puppetdb = true
) {
  include ::profile::base

  if ($puppetdb == true) {
    class { '::puppetdb' }
  }
}
