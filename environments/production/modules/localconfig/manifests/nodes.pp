
###############
## WEB PROXY ##
###############

node 'web0' inherits webnode { }

node 'web1' inherits webnode { }


###############
## APP NODES ##
###############

node 'app0' inherits appnode { }

node 'app1' inherits appnode { }

node 'app2' inherits appnode { }

node 'app3' inherits appnode { }

####################
## ACTIVITY NODES ##
####################

node 'activity0' inherits activitynode { }

node 'activity1' inherits activitynode { }

node 'activity2' inherits activitynode { }

node 'activity3' inherits activitynode { }

node 'activity4' inherits activitynode { }

node 'activity5' inherits activitynode { }

#####################
## CASSANDRA NODES ##
#####################

node 'db0' inherits dbnode {
  class { 'cassandra::common':
    owner           => $localconfig::db_user,
    group           => $localconfig::db_group,
    hosts           => $localconfig::db_hosts,
    listen_address  => $localconfig::db_hosts[0],
    cluster_name    => $localconfig::db_cluster_name,
    initial_token   => $localconfig::db_initial_tokens[0],
  }

  class { 'opscenter':
    require => Class['cassandra::common'],
  }

  class { 'munin::client':
    hostname => 'db0',
    require  => Class['cassandra::common'],
  }
}

node 'db1' inherits dbnode {
  class { 'cassandra::common':
    owner           => $localconfig::db_user,
    group           => $localconfig::db_group,
    hosts           => $localconfig::db_hosts,
    listen_address  => $localconfig::db_hosts[1],
    cluster_name    => $localconfig::db_cluster_name,
    initial_token   => $localconfig::db_initial_tokens[1],
  }

  class { 'munin::client':
    hostname => 'db1',
    require  => Class['cassandra::common'],
  }
}

node 'db2' inherits dbnode {
  class { 'cassandra::common':
    owner           => $localconfig::db_user,
    group           => $localconfig::db_group,
    hosts           => $localconfig::db_hosts,
    listen_address  => $localconfig::db_hosts[2],
    cluster_name    => $localconfig::db_cluster_name,
    initial_token   => $localconfig::db_initial_tokens[2],
  }

  class { 'munin::client':
    hostname => 'db2',
    require  => Class['cassandra::common'],
  }
}

node 'db3' inherits dbnode {
  class { 'cassandra::common':
    owner           => $localconfig::db_user,
    group           => $localconfig::db_group,
    hosts           => $localconfig::db_hosts,
    listen_address  => $localconfig::db_hosts[3],
    cluster_name    => $localconfig::db_cluster_name,
    initial_token   => $localconfig::db_initial_tokens[3],
  }

  class { 'munin::client':
    hostname => 'db3',
    require  => Class['cassandra::common'],
  }
}

node 'db4' inherits dbnode {
  class { 'cassandra::common':
    owner           => $localconfig::db_user,
    group           => $localconfig::db_group,
    hosts           => $localconfig::db_hosts,
    listen_address  => $localconfig::db_hosts[4],
    cluster_name    => $localconfig::db_cluster_name,
    initial_token   => $localconfig::db_initial_tokens[4],
  }

  class { 'munin::client':
    hostname => 'db4',
    require  => Class['cassandra::common'],
  }
}

node 'db5' inherits dbnode {
  class { 'cassandra::common':
    owner           => $localconfig::db_user,
    group           => $localconfig::db_group,
    hosts           => $localconfig::db_hosts,
    listen_address  => $localconfig::db_hosts[5],
    cluster_name    => $localconfig::db_cluster_name,
    initial_token   => $localconfig::db_initial_tokens[5],
  }

  class { 'munin::client':
    hostname => 'db5',
    require  => Class['cassandra::common'],
  }
}

##################
## SEARCH NODES ##
##################

node 'search0' inherits linuxnode {
  class { 'elasticsearch':
    path_data     => $localconfig::search_path_data,
    host_address  => $localconfig::search_hosts_internal[0]['host'],
    host_port     => $localconfig::search_hosts_internal[0]['port'],
    max_memory_mb => 3072,
    min_memory_mb => 3072,
  }

  class { 'rsyslog': server_host => $localconfig::rsyslog_host_internal, }
}

node 'search1' inherits linuxnode {
  class { 'elasticsearch':
    path_data     => $localconfig::search_path_data,
    host_address  => $localconfig::search_hosts_internal[1]['host'],
    host_port     => $localconfig::search_hosts_internal[1]['port'],
    max_memory_mb => 3072,
    min_memory_mb => 3072,
  }

  class { 'rsyslog': server_host => $localconfig::rsyslog_host_internal, }
}

#################
## REDIS NODES ##
#################

node 'cache-master' inherits basenode {
  class { 'redis': }
  class { 'ipfilter': }
  class { 'rsyslog': server_host => $localconfig::rsyslog_host_internal, }
}

node 'cache-slave' inherits basenode {
  class { 'redis':
    slave_of  => $localconfig::redis_hosts[0],
  }
  class {'ipfilter': }
  class { 'rsyslog': server_host => $localconfig::rsyslog_host_internal, }
}

node 'activity-cache-master' inherits basenode {
  class { 'redis':
    eviction_maxmemory  => 3758096384,
    eviction_policy     => 'volatile-ttl',
    eviction_samples    => 3
  }
  class {'ipfilter': }
  class { 'rsyslog': server_host => $localconfig::rsyslog_host_internal, }
}

node 'activity-cache-slave' inherits basenode {
  class { 'redis':
    eviction_maxmemory  => 3758096384,
    eviction_policy     => 'volatile-ttl',
    eviction_samples    => 3,
    slave_of            => $localconfig::activity_redis_hosts[0]
  }
  class {'ipfilter': }
  class { 'rsyslog': server_host => $localconfig::rsyslog_host_internal, }
}

#####################
## MESSAGING NODES ##
#####################

node 'mq-master' inherits linuxnode {
  class { 'rabbitmq':
    listen_address  => $localconfig::mq_hosts_internal[0]['host'],
    listen_port     => $localconfig::mq_hosts_internal[0]['port'],
  }

  class { 'rsyslog': server_host => $localconfig::rsyslog_host_internal, }
}

#############################
## PREVIEW PROCESSOR NODES ##
#############################

node 'pp0' inherits ppnode { }

node 'pp1' inherits ppnode { }

node 'pp2' inherits ppnode { }

#################
## SYSLOG NODE ##
#################

node 'syslog' inherits syslognode { }

#############
## BASTION ##
#############

node 'bastion' inherits linuxnode {
  
  

  ##########################
  ## WEB TRAFFIC HANDLING ##
  ##########################

  # Route web traffic to web0
  iptables { '001 route web :80 traffic to web0':
    chain     => 'PREROUTING',
    table     => 'nat',
    iniface   => 'eth0',
    proto     => 'tcp',
    dport     => [ 80, 443 ],
    jump      => 'DNAT',
    todest    => $localconfig::web_hosts[0],
  }

  # Masquerade - scrub the internal interface from outbound packets?
  iptables { '001 route web masquerade':
    chain     => 'POSTROUTING',
    table     => 'nat',
    jump      => 'MASQUERADE',
  }

  # Accept forwarded web traffic with a rate limit
  # iptables -A INPUT -p tcp --dport 80 -m state --state NEW -m limit --limit 50/minute --limit-burst 200 -j ACCEPT
  iptables { '001 rate limit new forwarded web connections':
    chain     => 'FORWARD',
    iniface   => 'eth0',
    proto     => 'tcp',
    state     => 'NEW',
    dport     => [ 80, 443 ],
    limit     => '50/minute',
    burst     => 200,
    jump      => 'ACCEPT',
  }

  # iptables -A INPUT -m state --state RELATED,ESTABLISHED -m limit --limit 50/second --limit-burst 50 -j ACCEPT
  iptables { '001 rate limit established forwarded webc onnections':
    chain     => 'FORWARD',
    iniface   => 'eth0',
    proto     => 'tcp'
    state     => ['RELATED', 'ESTABLISHED'],
    dport     => [80, 443],
    limit     => '50/second',
    burst     => 50,
    jump      => 'ACCEPT',
  }
}
