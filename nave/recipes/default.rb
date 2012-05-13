me = node[:main_user]

include_recipe "build-essential"

case node[:platform]
when "centos","redhat","fedora"
  package "openssl-devel"
when "debian","ubuntu"
  package "libssl-dev"
end

directory "/home/#{me}/.nave" do
  owner me
  group me
  mode "0755"
  action :create
end

git "/home/#{me}/.nave" do
  repository "git://github.com/isaacs/nave.git"
  reference "master"
  action :sync
end

bash "create link" do
  user "root"
  cwd "/home/#{me}"
  code <<-EOH
    ln -s /home/#{me}/.nave/nave/nave.sh /usr/local/bin/nave
    nave install 0.6.15
  EOH
end
