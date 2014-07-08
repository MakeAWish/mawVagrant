# -*- mode: ruby -*-
# vi: set ft=ruby :


Vagrant.configure("2") do |config|
  ## Choose your base box
  config.vm.box = "gsoi-php55"
  config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/precise/20140623/precise-server-cloudimg-amd64-vagrant-disk1.box"

  not_windows = RUBY_PLATFORM =~ /darwin/ || RUBY_PLATFORM =~ /linux/
  nfs_setting = RUBY_PLATFORM =~ /darwin/ || RUBY_PLATFORM =~ /linux/ 
  # || Vagrant.has_plugin?("vagrant-winnfsd")
  # config.winnfsd.logging = "on"

  ## For masterless, mount your file roots file root
  config.vm.synced_folder "salt/roots/", "/srv/", :nfs => not_windows

  # Projects
  if Dir.exists?('projects/mawDevs/')
    config.vm.synced_folder "projects/mawDevs/", "/var/www/maw/", :nfs => nfs_setting
  end
  
  # Network
  config.vm.network :private_network, ip: '10.0.0.169'
  config.vm.network :public_network
  config.vm.hostname = "maw.local"

  if not_windows
    if Vagrant.has_plugin?("vagrant-hostsupdater")
      config.hostsupdater.aliases = [
        "maw.local",
      ]
      config.hostsupdater.remove_on_suspend = true
    else
      puts 'You should install vagrant-hostsupdater plugin for automatic hosts update'
    end
   else
     puts 'Vous devez ajoutez ces enregistrements dans votre fichier hosts :'
     puts '10.0.0.169 maw.local' 
  end

  config.vm.provider :virtualbox do |vb|
    vb.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/.", "1"]
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--memory", 2048]
    vb.customize ["modifyvm", :id, "--name", "maw"]
  end

  ## Set your salt configs here
  config.vm.provision :salt do |salt|

    ## Minion config is set to ``file_client: local`` for masterless
    salt.minion_config = "salt/minion"

    ## Installs our example formula in "salt/roots/salt"
    salt.run_highstate = true

    salt.verbose = true

  end
end