$etcd_service = @("SERVICE"/L)
[Unit]
Description=etcd key-value store
Documentation=https://github.com/coreos/etcd
After=network.target

[Service]
Environment=ETCD_DATA_DIR=/var/lib/etcd
Environment=ETCD_NAME=%m
ExecStart=/usr/bin/etcd
Restart=always
RestartSec=10s
LimitNOFILE=40000

[Install]
WantedBy=multi-user.target
    | SERVICE

package { 'etcd':
  ensure => latest,
} ->
file { '/etc/systemd/system/etcd.service':
  ensure => present,
  content => $etcd_service,
} ~>
service { 'etcd':
  ensure => running,
  enable => true,
}
