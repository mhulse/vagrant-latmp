NETWORK_IP = '192.168.100.101' # Blank for DHCP, or `192.168.x.x` for static IP.
PHP_VERSION = '5.6' # Available options: 5.4, 5.5, 5.6, 7.0, 7.1, 7.2
PHP_MEMORY_LIMIT = 256
PHP_TIMEZONE = 'America/Los_Angeles'
PHP_MAX_EXECUTION_TIME = 60

Vagrant.configure(2) do |config|
  
  # https://app.vagrantup.com/boxes/search
  # https://app.vagrantup.com/bento/boxes/centos-7.3
  config.vm.box = 'bento/centos-7.3'
  
  forwareded_port_defaults = {
    auto_correct: true,
  }
  
  # HTTP
  config.vm.network(
    'forwarded_port',
    forwareded_port_defaults.merge!({
      guest: 80,
      host: 80,
    })
  )
  # HTTPS
  config.vm.network(
    'forwarded_port',
    forwareded_port_defaults.merge!({
      guest: 443,
      host: 443,
    })
  )
  # MySQL
  config.vm.network(
    'forwarded_port',
    forwareded_port_defaults.merge!({
      guest: 3306,
      host: 3306,
    })
  )
  # phpMyAdmin
  config.vm.network(
    'forwarded_port',
    forwareded_port_defaults.merge!({
      guest: 9000,
      host: 9000,
    })
  )
  
  # Network configuration:
  config.vm.network(
    'private_network',
    (
      if NETWORK_IP.to_s.empty?
        {
          type: 'dhcp',
        }
      else
        {
          ip: NETWORK_IP
        }
      end
    )
  )
  
  # Uncomment this if you want bridged network functionality:
  #config.vm.network('public_network')
  
  config.vm.provider 'virtualbox' do |vb|

    # Boost memory usage:
    vb.customize [
      'modifyvm',
      :id,
      '--memory',
      1024
    ]
    
  end
  
  # SSH agent forwarding?
  config.ssh.forward_agent = true
  
  # Shared directory configuration defaults:
  synced_folder_defaults = {
    create: true,
    owner: 'vagrant',
    group: 'vagrant',
    mount_options: [
      'dmode=775',
      'fmode=664',
    ],
  }
  
  # Disable the default share:
  config.vm.synced_folder(
    '.',
    '/vagrant', {
      id: 'vagrant-root',
      disabled: true,
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
      id: 'http-conf.',
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
  
  config.vm.provision(
    'shell',
    {
      path: 'bootstrap.sh',
      args: [
        "-e#{PHP_MAX_EXECUTION_TIME}",
        "-m#{PHP_MEMORY_LIMIT}",
        "-t#{PHP_TIMEZONE}",
        "-v#{PHP_VERSION}",
      ]
    }
  )
  
end
