default['nginx']['listen_port'] = 80
default['nginx']['worker_processes'] = 1
default['nginx']['worker_connections'] = 1024
default['nginx']['keepalive_timeout'] = 65
default['php']['web_user'] = 'nginx'
default['php']['web_group'] = 'nginx'