#
# Ubuntu Server 18.04 LTS (Bionic Beaver)
# Basic packages
# Installs multiple packages on Ubuntu Server 18.04 (Bionic Beaver)
#
# Author: Pavel Petrov <papahelmsman@gmail.com>
#

.PHONY: all preparations libs update upgrade fonts

all:
	@echo "Installation of all targets"
	make update
	make upgrade
	make prerequisites
	make git

update:
	@echo "→ Update package lists"
	sudo apt update
	@echo "✔ Done"

upgrade:
	@echo "→ Fetch new versions of packages"
	sudo apt -y upgrade
	@echo "✔ Done"

prerequisites:
	sudo apt install wget curl git

	zip unzip screen curl ffmpeg libfile-fcntllock-perl tree



git:
	sudo add-apt-repository -y ppa:git-core/ppa
	make update
	sudo apt -y install git

nginx-prerequisites:
	sudo apt install curl gnupg2 ca-certificates lsb-release

nginx-install:
	echo "deb http://nginx.org/packages/mainline/ubuntu `lsb_release -cs` nginx" \
        | sudo tee /etc/apt/sources.list.d/nginx.list
	curl -fsSL https://nginx.org/keys/nginx_signing.key | sudo apt-key add -
	sudo apt-key fingerprint ABF5BD827BD9BF62
	make update
	sudo apt install -y nginx



prepare:
	sudo -s
	apt install -y wget gnupg2 git
	# alrady installed: wget
	cd /usr/local/src
mv /etc/apt/sources.list /etc/apt/sources.list.bak && touch /etc/apt/sources.list
cat <<EOF >>/etc/apt/sources.list
deb http://archive.ubuntu.com/ubuntu bionic main multiverse restricted universe
deb http://archive.ubuntu.com/ubuntu bionic-security main multiverse restricted universe
deb http://archive.ubuntu.com/ubuntu bionic-updates main multiverse restricted universe
deb http://ppa.launchpad.net/ondrej/php/ubuntu bionic main
deb http://ppa.launchpad.net/ondrej/nginx-mainline/ubuntu bionic main
deb [arch=amd64] http://ftp.hosteurope.de/mirror/mariadb.org/repo/10.3/ubuntu bionic main
EOF
apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 4F4EA0AAE5267A6C
apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8
apt update && apt upgrade -y && apt install software-properties-common zip unzip screen curl ffmpeg libfile-fcntllock-perl tree -y
apt update && apt upgrade -y && apt install ssl-cert -y && make-ssl-cert generate-default-snakeoil
apt remove nginx nginx-extras nginx-common nginx-full -y --allow-change-held-packages
apt install nginx nginx-extras -y && systemctl enable nginx.service

nginx:
	sudo -s
    cd /usr/local/src
    wget http://nginx.org/keys/nginx_signing.key && apt-key add nginx_signing.key


    apt update
    mkdir /usr/local/src/nginx && cd /usr/local/src/nginx/
    apt install dpkg-dev -y && apt source nginx
    # cd /usr/local/src && apt install git -y
    git clone https://github.com/openssl/openssl.git
    cd openssl && git branch -a
    git checkout OpenSSL_1_1_1-stable
    nano /usr/local/src/nginx/nginx-1.15.12/debian/rules

preparations:
	sudo apt install -y

libs:
	sudo apt -y install libavahi-compat-libdnssd-dev

ufw-nginx:
	sudo ufw allow "Full Nginx"

fonts:
	mkdir -p ~/.fonts/
	rm -f ~/.fonts/FiraCode-*
	wget https://github.com/tonsky/FiraCode/raw/master/distr/otf/FiraCode-Bold.otf -O ~/.fonts/FiraCode-Bold.otf
	wget https://github.com/tonsky/FiraCode/raw/master/distr/otf/FiraCode-Light.otf -O ~/.fonts/FiraCode-Light.otf
	wget https://github.com/tonsky/FiraCode/raw/master/distr/otf/FiraCode-Medium.otf -O ~/.fonts/FiraCode-Medium.otf
	wget https://github.com/tonsky/FiraCode/raw/master/distr/otf/FiraCode-Regular.otf -O ~/.fonts/FiraCode-Regular.otf
	wget https://github.com/tonsky/FiraCode/raw/master/distr/otf/FiraCode-Retina.otf -O ~/.fonts/FiraCode-Retina.otf
	fc-cache -v

docker-prerequisites:
	## TESTED
	sudo apt install \
		apt-transport-https \
		ca-certificates \
		curl \
		gnupg-agent \
		software-properties-common

docker:
	## TESTED
	sudo apt remove docker docker-engine docker.io containerd runc
	make update
	make docker-prerequisites
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

	## sudo apt-key fingerprint 0EBFCD88
	##
	## pub   rsa4096 2017-02-22 [SCEA]
    ##       9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88
    ## uid           [ unknown] Docker Release (CE deb) <docker@docker.com>
    ## sub   rsa4096 2017-02-22 [S]
	## sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"

	echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu `lsb_release -cs` stable" \
            | sudo tee /etc/apt/sources.list.d/docker.list

    make update
    sudo apt install -y docker-ce docker-ce-cli containerd.io

	## apt-cache madison docker-ce
	##
	## docker-ce | 5:18.09.6~3-0~ubuntu-bionic | https://download.docker.com/linux/ubuntu bionic/stable amd64 Packages
	## docker-ce | 5:18.09.5~3-0~ubuntu-bionic | https://download.docker.com/linux/ubuntu bionic/stable amd64 Packages
	## docker-ce | 5:18.09.4~3-0~ubuntu-bionic | https://download.docker.com/linux/ubuntu bionic/stable amd64 Packages
	## docker-ce | 5:18.09.3~3-0~ubuntu-bionic | https://download.docker.com/linux/ubuntu bionic/stable amd64 Packages
	## docker-ce | 5:18.09.2~3-0~ubuntu-bionic | https://download.docker.com/linux/ubuntu bionic/stable amd64 Packages
	## docker-ce | 5:18.09.1~3-0~ubuntu-bionic | https://download.docker.com/linux/ubuntu bionic/stable amd64 Packages
	## docker-ce | 5:18.09.0~3-0~ubuntu-bionic | https://download.docker.com/linux/ubuntu bionic/stable amd64 Packages
	## docker-ce | 18.06.3~ce~3-0~ubuntu | https://download.docker.com/linux/ubuntu bionic/stable amd64 Packages
	## docker-ce | 18.06.2~ce~3-0~ubuntu | https://download.docker.com/linux/ubuntu bionic/stable amd64 Packages
	## docker-ce | 18.06.1~ce~3-0~ubuntu | https://download.docker.com/linux/ubuntu bionic/stable amd64 Packages
	## docker-ce | 18.06.0~ce~3-0~ubuntu | https://download.docker.com/linux/ubuntu bionic/stable amd64 Packages
	## docker-ce | 18.03.1~ce~3-0~ubuntu | https://download.docker.com/linux/ubuntu bionic/stable amd64 Packages

	# sudo docker run hello-world

	# docker --version

	sudo groupadd docker
	sudo usermod -aG docker $USER
	## REBOOT

docker-compose:
	## TESTED
	make update
	sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
	sudo chmod +x /usr/local/bin/docker-compose
	sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

	# docker-compose --version

	## UNINSTALL
	## sudo rm /usr/local/bin/docker-compose

ansible:
	# Not Tested
	sudo add-apt-repository -y ppa:ansible/ansible
	make update
	sudo apt -y install ansible
	# ansible --version

	ssh-keygen -t rsa -b 4096 -C "papahelmsman@gmail.com"




