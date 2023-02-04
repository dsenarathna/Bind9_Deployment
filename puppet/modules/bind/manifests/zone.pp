# Definition: bind::zone
#
# This class installs Bind zones
#
# Parameters:
#   - The $name of the zone
#
# Actions:
#   - Install Bind zones
#
# Requires:
#
# Sample Usage:
#   bind::zone { 'domainname': }
#
define bind::zone {
  file {
    "/etc/bind/world/${name}.zone":
      owner   => 'root',
      group   => 'bind',
      mode    => '0644',
      notify  => Service['bind9-reload'],
      content => template("${::puppet_dir_master}/systems/_LINUX_/etc/bind/world/${name}.zone"),
      require => Package['bind9'];
  }
}
