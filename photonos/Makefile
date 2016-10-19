FLAGS = --rm --privileged -v /tmp:/tmp -v /etc:/etc -v /var:/var -v /usr:/usr -v /var/run/dbus:/var/run/dbus -v /run/systemd:/run/systemd

facter:
	vagrant ssh -c "docker run $(FLAGS) --net host puppet/facter"

agent:
	vagrant ssh -c "docker run $(FLAGS) --link puppet:puppet puppet/puppet-agent"

sync: manifests
	vagrant provision --provision-with file

apply: sync
	vagrant ssh -c "docker run $(FLAGS) -v /tmp/puppet:/var/puppet puppet/puppet-agent apply /var/puppet/manifests/init.pp --verbose"

reset:
	vagrant ssh -c "sudo systemctl stop etcd; sudo rm /etc/systemd/system/etcd.service; sudo tdnf remove -y etcd"

.PHONY: facter agent apply sync
