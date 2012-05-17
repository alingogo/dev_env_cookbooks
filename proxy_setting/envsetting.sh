#!/bin/sh

echo "ユーザ名を入力してください"
read USER

echo "パスワードを入力してください"
read PASSWD

echo "プロキシのホストネームとポートを入力してください"
echo "例 proxy.example.com:9090"
read PROXY

echo "svnのホストネームを入力してください"
read SVNH

echo "sshプロキシのホストネームとポートを入力してください"
echo "例 proxy.example.com:9090"
read SSHPROXY

echo "...ToT..."
echo "bashrcを作成する"
if [ -f bashrc.tmp ]; then
        cp bashrc.tmp bashrc
else
  echo "there is no bashrc.tmp"
  exit 0
fi

sed -i "s/\-user\-/$USER/g" bashrc
sed -i "s/\-passwd\-/$PASSWD/g" bashrc
sed -i "s/\-proxy\-/$PROXY/g" bashrc
sed -i "s/\-svnhostname\-/$SVNH/g" bashrc

mv bashrc $HOME/.bashrc
source $HOME/.bashrc

echo "...ToT..."
echo "git-proxyを設定する"
if ls -l /usr/bin/connect; then
  echo "connect is ready"
else
  wget http://www.meadowy.org/~gotoh/ssh/connect.c
  sudo gcc connect.c -o connect
  sudo mv connect /usr/bin/
  rm connect.c
fi

if grep "github.com" $HOME/.ssh/config; then
  echo "github.com is ready"
else
  cat >> $HOME/.ssh/config <<_EOF_
  Host github.com
  User git
  HostName github.com
  ProxyCommand /usr/bin/connect -S $SSHPROXY %h %p
  IdentityFile $HOME/.ssh/id_rsa.git
_EOF_
fi
chmod 0600 $HOME/.ssh/config

echo "...ToT..."
echo "秘密keyの設定がわすれないようにください"
# .ssh/id_rsa.git
# .ssh/id_rsa.git.pub

if [ -f git-proxy.tmp ]; then
     cp git-proxy.tmp git-proxy
else
  echo "there is no git-proxy.tmp"
  exit 0
fi

sed -i "s/\-user\-/$USER/g" git-proxy
sed -i "s/\-sshproxy\-/$SSHPROXY/g" git-proxy
sudo mv git-proxy /usr/bin/.
sudo chmod a+x /usr/bin/git-proxy

source $HOME/.bashrc

echo "...ToT..."
echo "設定完了"
