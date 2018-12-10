# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # Specify your hostname if you like
  # config.vm.hostname = "name"
  config.vm.box = "bento/ubuntu-16.04"
  config.vm.provider "virtualbox" do |v|
    v.memory = 5120
    v.cpus = 4
  end
  config.vm.provision "file", source: "~/.gcloud/gcloud.json", destination: "~/.gcloud/gcloud.json"
  config.vm.provision "docker"
  config.vm.provision "ansible_local" do |ansible|
    ansible.install_mode = :pip
    ansible.pip_args = "google-auth requests influxdb"
    ansible.playbook = "playbook.yml"
    ansible.inventory_path = "iventory.gcp.yml"
  end
  config.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "~/.ssh/me.pub"
end
