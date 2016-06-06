#!/bin/sh
#
# *** 最初にやる事 ***
# 1. LANG=C xdg-user-dirs-gtk-update の実行
#
# 2. sudoersに以下を追加する
# "ユーザ名" ALL=(ALL)       NOPASSWD:ALL
#
TMP_DIR="~/setup_files"

cd ~
mkdir $TMP_DIR

sudo yum -y update
sudo yum -y install gnome-shell-browser-plugin
sudo yum -y install epel-release

#--- mozc install
cd $TMP_DIR

## get rpm files
wget ftp://ftp.pbone.net/mirror/archive.fedoraproject.org/fedora/linux/releases/19/Everything/x86_64/os/Packages/i/ibus-mozc-1.10.1390.102-1.fc19.x86_64.rpm
wget ftp://ftp.pbone.net/mirror/archive.fedoraproject.org/fedora/linux/releases/19/Everything/x86_64/os/Packages/m/mozc-1.10.1390.102-1.fc19.x86_64.rpm
wget ftp://ftp.pbone.net/mirror/archive.fedoraproject.org/fedora/linux/releases/19/Everything/x86_64/os/Packages/p/protobuf-2.5.0-4.fc19.x86_64.rpm
wget ftp://ftp.pbone.net/mirror/archive.fedoraproject.org/fedora/linux/releases/19/Everything/x86_64/os/Packages/z/zinnia-0.06-16.fc19.x86_64.rpm
wget ftp://ftp.pbone.net/mirror/archive.fedoraproject.org/fedora/linux/releases/19/Everything/x86_64/os/Packages/z/zinnia-tomoe-0.06-16.fc19.x86_64.rpm
wget ftp://ftp.pbone.net/mirror/archive.fedoraproject.org/fedora/linux/releases/19/Everything/x86_64/os/Packages/e/emacs-mozc-1.10.1390.102-1.fc19.noarch.rpm
wget ftp://ftp.pbone.net/mirror/archive.fedoraproject.org/fedora/linux/releases/19/Everything/x86_64/os/Packages/e/emacs-common-mozc-1.10.1390.102-1.fc19.x86_64.rpm

## install mozc
sudo yum -y localinstall protobuf-2.5.0-4.fc19.x86_64.rpm zinnia-0.06-16.fc19.x86_64.rpm zinnia-tomoe-0.06-16.fc19.x86_64.rpm mozc-1.10.1390.102-1.fc19.x86_64.rpm ibus-mozc-1.10.1390.102-1.fc19.x86_64.rpm
## install emacs-mozc（sublime用）
sudo yum -y localinstall emacs-mozc-1.10.1390.102-1.fc19.noarch.rpm emacs-common-mozc-1.10.1390.102-1.fc19.x86_64.rpm

#--- Ricty install
cd $TMP_DIR
sudo yum -y install fontforge

## get files
wget https://github.com/yascentur/Ricty/archive/3.2.2.zip
unzip 3.2.2.zip
cd Ricty-3.2.2/
wget http://levien.com/type/myfonts/Inconsolata.otf
wget "http://sourceforge.jp/frs/redir.php?m=jaist&f=%2Fmix-mplus-ipa%2F59022%2Fmigu-1m-20130617.zip"
unzip redir.php\?m\=jaist\&f\=%2Fmix-mplus-ipa%2F59022%2Fmigu-1m-20130617.zip
cp migu-1m-20130617/migu-1m-bold.ttf ./
cp migu-1m-20130617/migu-1m-regular.ttf ./
./ricty_generator.sh -v -w Inconsolata.otf migu-1m-regular.ttf migu-1m-bold.ttf

## install font
mkdir -p ~/.fonts
cp -f Ricty*.ttf ~/.fonts/
fc-cache -vf

#--- Python install
# http://blog.umentu.work/?p=153
cd $TMP_DIR

## get dev packages
sudo yum install openssl-devel bzip2-devel zlib-devel readline-devel sqlite-devel ncurses-devel tk-devel atlas-devel lapack-devel

## install pyenv & pyenv-virtualenv
git clone git://github.com/yyuu/pyenv.git ~/.pyenv
git clone git://github.com/yyuu/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv

## set PATH
cat << 'EOF' >> ~/.bashrc
# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="${PYENV_ROOT}/bin:${PATH}"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
EOF
exec $SHELL

#--- Mecab install
cd $TMP_DIR

## mecab
wget https://mecab.googlecode.com/files/mecab-0.996.tar.gz
tar zxf mecab-0.996.tar.gz
cd mecab-0.996
./configure --with-charset=utf8
make
sudo make install
cd ..
## mecab dictionaly
wget http://mecab.googlecode.com/files/mecab-ipadic-2.7.0-20070801.tar.gz
tar zxf mecab-ipadic-2.7.0-20070801.tar.gz
cd mecab-ipadic-2.7.0-20070801
./configure --with-charset=utf8
make
sudo make install
cd ..

# --- Texlive install
cd $TMP_DIR
## mount texlive
wget http://ring.airnet.ne.jp/pub/text/CTAN/systems/texlive/Images/texlive2015-20150523.iso
sudo mkdir /mnt/iso
sudo mount -o loop -t iso9660 texlive2015-20150523.iso /mnt/iso
## install texlive
sudo /mnt/iso/install-tl
cat << 'EOF' >> ~/.bashrc
# texlive
PATH=/usr/local/texlive/2015/bin/x86_64-linux:$PATH; export PATH
INFOPATH=/usr/local/texlive/2015/texmf-dist/doc/info:$INFOPATH; export INFOPATH
MANPATH=/usr/local/texlive/2015/texmf-dist/doc/man:$MANPATH; export MANPATH
EOF
## unmount texlive iso
sudo umount /mnt/iso
sudo rmdir /mnt/iso
