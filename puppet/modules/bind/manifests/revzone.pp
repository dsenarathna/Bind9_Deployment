# Definition: bind::revzone
#
# This class installs Bind reversed zones
#
# Parameters:
#   - The $name of the zone
#
# Actions:
#   - Install Bind reversed zones
#
# Requires:
#
# Sample Usage:
#   bind::revzone { '0.120.10': }
#
define bind::revzone {
  file {
    "/etc/bind/world/${name}.in-addr.arpa.zone":
      owner   => 'root',
      group   => 'bind',
      mode    => '0644',
      notify  => Service['bind9-reload'],
      content => template("${::puppet_dir_master}/systems/_LINUX_/etc/bind/world/${name}.in-addr.arpa.zone"),
      require => Package['bind9'];
  }
}
