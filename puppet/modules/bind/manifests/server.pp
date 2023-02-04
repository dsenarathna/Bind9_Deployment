# Class: bind::server
#
# This class installs a Bind DNS server
#
# Parameters:
#
# Actions:
#   bind::zone { Install Bind
#   bind::zone { Manage Bind service
#
# Requires:
#
# Sample Usage:
#
class bind::server {
  $bind_forwarders_searchignite = hiera('bind_forwarders_searchignite')
  $bind_hosts_query             = hiera('bind_hosts_query')
  $bind_hosts_transfer          = hiera('bind_hosts_transfer')
  $bind_hosts_recursion         = hiera('bind_hosts_recursion')
  $bind_ip_master               = hiera('bind_ip_master')
  $bind_ip_master_slave         = hiera('bind_ip_master_slave')
  $bind_logging_severity        = hiera('bind_logging_severity')
  $bind_revzones                = hiera_array('bind_revzones', [])
  $bind_zones                   = hiera_array('bind_zones', [])
  $bind_zones_geo               = hiera_array('bind_zones_geo', [])

  if $::role_dns_master {
    $bind_type = 'master'
  } elsif $::role_dns_master_slave or $::role_dns_slave {
    $bind_type = 'slave'
  }

  package {
    'bind9':
      ensure => installed;
  }

  service {
    'bind9':
      ensure     => running,
      enable     => true,
      hasrestart => true,
      hasstatus  => true,
      require    => Package['bind9'];
  }
  
  service {
    'bind9-reload':
      pattern  => '/usr/sbin/named',
      provider => 'base',
      restart  => '/etc/init.d/bind9 reload',
      require  => Package['bind9'];
  }

  file {
    '/etc/bind':
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0755';
    '/etc/bind/be-bru':
      ensure  => directory,
      owner   => 'root',
      group   => 'bind',
      mode    => '0775',
      require => Package['bind9'];
    '/etc/bind/named.conf':
      owner   => 'root',
      group   => 'bind',
      mode    => '0644',
      notify  => Service['bind9'],
      content => template("${::puppet_dir_master}/systems/_LINUX_/etc/bind/named.conf"),
      require => Package['bind9'];
    '/etc/bind/named.conf.local':
      owner   => 'root',
      group   => 'bind',
      mode    => '0644',
      notify  => Service['bind9'],
      content => template("${::puppet_dir_master}/systems/_LINUX_/etc/bind/named.conf.local"),
      require => Package['bind9'];
    '/etc/bind/named.conf.options':
      owner   => 'root',
      group   => 'bind',
      mode    => '0644',
      notify  => Service['bind9'],
      content => template("${::puppet_dir_master}/systems/_LINUX_/etc/bind/named.conf.options"),
      require => Package['bind9'];
    '/etc/bind/named.conf.zones':
      owner   => 'root',
      group   => 'bind',
      mode    => '0644',
      notify  => Service['bind9'],
      content => template("${::puppet_dir_master}/systems/_LINUX_/etc/bind/named.conf.zones"),
      require => Package['bind9'];
    '/etc/bind/rndc.key':
      owner   => 'bind',
      group   => 'bind',
      mode    => '0640',
      notify  => Service['bind9'],
      source  => 'puppet:///puppet_dir_master/systems/_LINUX_/etc/bind/rndc.key',
      require => Package['bind9'];
    '/etc/bind/world':
      ensure  => directory,
      owner   => 'root',
      group   => 'bind',
      mode    => '0775',
      require => Package['bind9'];
    '/var/log/bind':
      ensure  => directory,
      owner   => 'root',
      group   => 'bind',
      mode    => '1770',
      require => Package['bind9'];
  }

  if $::role_dns_master {
    #disable deploy of systems zone files in favor of foreman DNS API
    #bind::revzone { $bind_revzones: }
    #bind::zone { $bind_zones: }
    bind::zone { 'development.ignitionone.com': }
    bind::zone { 'development.netmining.com': }
    bind::zone { 'development.netmng.com': }
    bind::zone { 'qa.ignitionone.com': }
    bind::zone { 'qa.netmining.com': }
    bind::zone { 'qa.netmng.com': }
    bind::zone { 'test.ignitionone.com': }
    bind::zone { 'test.netmining.com': }
    bind::zone { 'test.netmng.com': }
  }
}
