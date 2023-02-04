# Definition: bind::zone_geo
#
# This class installs Bind geo zones
#
# Parameters:
#   - The $name of the zone
#
# Actions:
#   - Install Bind geo zones
#
# Requires:
#
# Sample Usage:
#   bind::zone_geo { 'domainname': }
#
define bind::zone_geo {
  file {
    "/etc/bind/be-bru/${name}.zone":
      owner   => 'root',
      group   => 'bind',
      mode    => '0644',
      notify  => Service['bind9-reload'],
      content => template("${::puppet_dir_master}/systems/_LINUX_/etc/bind/be-bru/${name}.zone"),
      require => Package['bind9'];
    "/etc/bind/world/${name}.zone":
      owner   => 'root',
      group   => 'bind',
      mode    => '0644',
      notify  => Service['bind9-reload'],
      content => template("${::puppet_dir_master}/systems/_LINUX_/etc/bind/world/${name}.zone"),
      require => Package['bind9'];
  }
}
