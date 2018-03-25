NETWORK_IP = '' # Blank for DHCP, or `192.168.x.x` for static IP.
NETWORK_TYPE = 'public' # Valid values: `public` or `private`
VM_MEMORY = 2048 # VM RAM usage.
VM_CPUS = 1 # VM CPU count.
VM_CPU_CAP = 50 # CPU execution cap percentage.

Vagrant.configure(2) do |config|

  # https://app.vagrantup.com/boxes/search
  config.vm.box = 'centos/7'

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

  # Shared directory configuration defaults (disabled if Windows):
  synced_folder_defaults = {
    disabled: ((Vagrant::Util::Platform.windows?) ? true : false),
    type: 'virtualbox',
    create: true,
    owner: 'root',
    group: 'root',
    mount_options: [
      'dmode=775',
      'fmode=664',
    ],
  }

  config.vm.synced_folder(
    '.',
    '/vagrant', {
      id: 'vagrant-root',
    }
  )

  # Apache HTTP Server:
  config.vm.synced_folder(
    './http/www',
    '/var/www',
    synced_folder_defaults.merge!({
      id: 'http-www',
    })
  )
  config.vm.synced_folder(
    './http/conf.d',
    '/etc/httpd/conf.d',
    synced_folder_defaults.merge!({
      id: 'http-conf',
    })
  )

  # Installing Apache Tomcat Server:
  config.vm.synced_folder(
    './tomcat/webapps',
    '/var/lib/tomcat/webapps',
    synced_folder_defaults.merge!({
      id: 'tomcat-webapps',
    })
  )
  config.vm.synced_folder(
    './tomcat/conf',
    '/etc/tomcat',
    synced_folder_defaults.merge!({
      id: 'tomcat-conf',
    })
  )
  config.vm.synced_folder(
    './tomcat/log',
    '/var/log/tomcat',
    synced_folder_defaults.merge!({
      id: 'tomcat-log',
    })
  )

  # Apache HTTP Server:
  config.vm.synced_folder(
    './node',
    '/var/node',
    synced_folder_defaults.merge!({
      id: 'node-root',
    })
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
      inline: 'echo "NETWORK IP: $(hostname -I | cut -d \  -f2)"',
      run: 'always',
    }
  )

end
