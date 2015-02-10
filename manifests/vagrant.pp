class role::vagrant {
  include profile::apache
  include profile::ruby
  include profile::node
  include profile::php
  include profile::postgresql
}
