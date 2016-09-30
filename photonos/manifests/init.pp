package { 'nginx':
	ensure => latest,
} ->
file { '/etc/nginx/html/index.html':
	content => 'Hello from Puppet',
} ~>
service { 'nginx':
	ensure => running,
	enable => true,
}
