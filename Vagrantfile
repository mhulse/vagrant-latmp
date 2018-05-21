NETWORK_IP = '' # Leave blank for DHCP, or `192.168.x.x` for a static IP
NETWORK_TYPE = 'public' # Valid values: `public` or `private`
VM_MEMORY = 2048 # VM RAM usage.
VM_CPUS = 1 # VM CPU count.
VM_CPU_CAP = 50 # CPU execution cap percentage.

Vagrant.configure(2) do |config|

  # https://app.vagrantup.com/boxes/search
  config.vm.box = 'bento/centos-7.4'

  # Defaults for forwarded port settings:
  forwareded_port_defaults = {
    auto_correct: true,
  }

  # HTTP:
  config.vm.network(
    'forwarded_port',
    forwareded_port_defaults.merge!({
      guest: 80,
      host: 80,
    })
  )
  # HTTPS:
  config.vm.network(
    'forwarded_port',
    forwareded_port_defaults.merge!({
      guest: 443,
      host: 443,
    })
  )
  # MailCatcher:
  config.vm.network(
    'forwarded_port',
    forwareded_port_defaults.merge!({
      guest: 1080,
      host: 1080,
    })
  )
  # MySQL:
  config.vm.network(
    'forwarded_port',
    forwareded_port_defaults.merge!({
      guest: 3306,
      host: 3306,
    })
  )

  # Network configuration:
  config.vm.network(
    (NETWORK_TYPE + '_network'),
    (
      if NETWORK_IP.to_s.empty?
        {
          type: 'dhcp',
        }
      else
        {
          ip: NETWORK_IP,
        }
      end
    )
  )

  config.vm.provider 'virtualbox' do |vb|

    # Boost memory usage:
    vb.customize [
      'modifyvm',
      :id,
      '--memory',
      VM_MEMORY,
    ]

    # Number of cpus:
    vb.customize [
      'modifyvm',
      :id,
      '--cpus',
      VM_CPUS,
    ]

    # Number of cpus:
    vb.customize [
      'modifyvm',
      :id,
      '--cpuexecutioncap',
      VM_CPU_CAP,
    ]

  end

  # SSH agent forwarding?
  config.ssh.forward_agent = true

  # https://github.com/mhulse/vagrant-latmp/issues/62
  # Login as root by default with NO password prompt:
  config.ssh.username = 'root'
  config.ssh.password = 'vagrant'
  config.ssh.insert_key = 'true'

  # Disable the default shared folder:
  config.vm.synced_folder(
    '.',
    '/vagrant',
    {
      disabled: true,
    }
  )

  # Command to obtain IP address of guest VM:
  show_network_ip = 'echo "NETWORK IP: $(hostname -I | cut -d \  -f2)"'

  config.vm.provision(
    'shell',
    {
      run: 'always',
      inline: show_network_ip,
    }
  )

  config.vm.provision(
    'shell',
    {
      path: 'bootstrap/init.sh',
    }
  )

  config.vm.provision(
    'shell',
    {
      inline: show_network_ip,
    }
  )

end
