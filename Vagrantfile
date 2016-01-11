# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  ## Choose your base box, not necessarily this one
  config.vm.box = 'precise-server-amd64'
  config.vm.box_url = 'https://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-amd64-vagrant-disk1.box'

  not_windows = RUBY_PLATFORM =~ /darwin/ || RUBY_PLATFORM =~ /linux/
  nfs_setting = RUBY_PLATFORM =~ /darwin/ || RUBY_PLATFORM =~ /linux/
  # || Vagrant.has_plugin?("vagrant-winnfsd")

  ## For masterless, mount your file roots file root
  config.vm.synced_folder 'salt/roots/', '/srv/', nfs: not_windows

  # Define projects Folders
  projects = []

  ## Projects folders
  projects.push('from' => 'projects/mawDevs/',
                     'to' => '/var/www/maw/')

  projects.push('from' => 'projects/mawDevs2/',
                     'to' => '/var/www/maw2/')

  projects.push('from' => 'projects/mawHtml/',
                     'to' => '/var/www/html/')

  # Register All Of The Configured Shared Folders
  projects.each do |project|
    next unless Dir.exist?(project['from'])
    config.vm.synced_folder project['from'], project['to'],
                            id: project['from'],
                            nfs: nfs_setting
  end

  # Network
  config.vm.network :private_network, ip: '10.0.0.169'
  config.vm.network :public_network
  config.vm.hostname = 'maw.lan'

  if not_windows
    if Vagrant.has_plugin?('vagrant-hostsupdater')
      config.hostsupdater.aliases = [
        'maw.lan',
        'maw2.lan'
      ]
      config.hostsupdater.remove_on_suspend = true
    else
      puts 'You should install vagrant-hostsupdater plugin for automatic hosts update'
    end
  else
    puts 'You should add the following matching to your host :'
    puts _vm_ip + ' maw.lan'
    puts _vm_ip + ' maw2.lan'
  end

  config.vm.provider :virtualbox do |vb|
    vb.customize ['setextradata', :id, 'VBoxInternal2/SharedFoldersEnableSymlinksCreate/.', '1']
    vb.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
    vb.customize ['modifyvm', :id, '--memory', 2048]
    vb.customize ['modifyvm', :id, '--name', 'maw']
  end

  ## Set your salt configs here
  config.vm.provision :salt do |salt|
    ## Minion config is set to ``file_client: local`` for masterless
    salt.minion_config = 'salt/minion'

    ## Installs our example formula in "salt/roots/salt"
    salt.run_highstate = true

    salt.verbose = false

    salt.bootstrap_options = '-F -c /tmp -P'
  end
end
