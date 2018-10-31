# -*- mode: ruby -*-
# vi: set ft=ruby :

$normal_user = <<-NORMAL_USER
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
echo "DID IT"
kubectl taint nodes --all node-role.kubernetes.io/master-
echo "DID IT"
kubectl create -f kubernetes/local-volumes.yaml
kubectl create -f kubernetes/postgres.yaml
kubectl create -f kubernetes/redis.yaml
kubectl create -f kubernetes/gitlab.yaml
kubectl get nodes
kubectl get svc gitlab
NORMAL_USER

# This script to install Kubernetes will get executed after we have provisioned the box 
$script = <<-SCRIPT
# Install kubernetes
apt-get update && apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
apt-get install -y kubelet kubeadm kubectl

# kubelet requires swap off
swapoff -a
# keep swap off after reboot
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

sed -i '/ExecStart=/a Environment="KUBELET_EXTRA_ARGS=--cgroup-driver=cgroupfs"' /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

# Get the IP address that VirtualBox has given this VM
IPADDR=10.0.0.101

# Set up Kubernetes
NODENAME=$(hostname -s)



kubeadm init --apiserver-cert-extra-sans=$IPADDR  --node-name $NODENAME

# Set up admin creds for the vagrant user
echo Copying credentials to /home/vagrant...
sudo --user=vagrant mkdir -p /home/vagrant/.kube
cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown $(id -u vagrant):$(id -g vagrant) /home/vagrant/.kube/config
docker pull gitlab/gitlab-ce:rc
SCRIPT

Vagrant.configure("2") do |config|
  # Specify your hostname if you like
  # config.vm.hostname = "name"
  config.vm.box = "bento/ubuntu-16.04"
  config.vm.provider "virtualbox" do |v|
    v.memory = 5120
    v.cpus = 4
  end
  config.vm.network "private_network", ip: "10.0.0.101"
  config.vm.network "forwarded_port", guest: 30080, host: 30080
  config.vm.network "forwarded_port", guest: 30022, host: 30022
  config.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "~/.ssh/me.pub"
  config.vm.provision "file", source: "./kubernetes", destination: "~/kubernetes"
  config.vm.provision "file", source: "./quickdestroy.sh", destination: "~/quickdestroy.sh"
  config.vm.provision "file", source: "./quickstart.sh", destination: "~/quickstart.sh"
  config.vm.provision "docker"
  config.vm.provision "shell", inline: $script
#  config.vm.provision "shell", privileged: false, inline: $normal_user 
end
