#
# Cookbook Name:: vimrc
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

#include_recipe "git"
#include_recipe "vim"
#include_recipe "ctags"

me = node[:main_user]

case node[:platform]
when "ubuntu"
  ruby "backup vim" do
    user me
    cwd "/home/#{me}"
    code <<-EOH
    name = ".vim"
    if File.directory?(name)
      case File::ftype(name)
      when "directory"
      	`cp -rp #{name} #{name + '_' + Time.now.strftime("%Y%m%d%H%M%S")}`
        Dir.rmdir(name)
      when "link"
      	File.unlink(name)
      end
    end
    File.unlink(".vimrc") if File.exist?(".vimrc")
    EOH
  end

  directory "/home/#{me}/eddie-vim" do
    owner me
    group me
    mode "0755"
    action :create
  end

  git "/home/#{me}/eddie-vim" do
    user me
    group me
    repository "git://github.com/kaochenlong/eddie-vim.git"
    reference "master"
    action :sync
  end

  bash "make vimrc" do
    user me
    cwd "/home/#{me}"
    code <<-EOH
    cd eddie-vim
    ./update.sh
    cd ..
    ln -s eddie-vim .vim
    ln -s eddie-vim/vimrc .vimrc
    EOH
  end
when "centos"
  #ToDo
when "mac"
  #ToDo
else
  #ToDo
end
