#
# Cookbook Name:: poweradmin
# Attribute:: default
#
# Copyright 2014, Naoya Nakazawa
#
# All rights reserved - Do Not Redistribute
#

default['poweradmin'] = {
  'version' => '2.1.6',
  'db_host' => 'localhost',
  'db_user' => '',
  'db_pass' => '',
  'db_name' => 'pdns',
  'db_port' => 3306,
  'db_type' => 'mysql',
  'db_layer' => 'MDB2',
  'dns_hostmaster' => '',
  'dns_ns1' => '',
  'dns_ns2' => '',
  'iface_lang' => 'en_US',
}
