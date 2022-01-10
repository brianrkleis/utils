#!/bin/bash

set -e

if [[ $EUID -ne 0 ]]; then
    echo "You need to run this script as root!"
    exit 1
fi

function curlTry() {

        command -v curl >/dev/null 2>&1 || { echo >&2 "Curl isn't installed. Please install curl.  Aborting."; exit 1; }
}

function dockerInstall() {

	if ! command -v docker &> /dev/null 
	then
        	curl -fsSL https://get.docker.com -o get-docker.sh
        	sh get-docker.sh
		rm -rf get-docker.sh
        	docker -v
        	docker run --rm hello-world
        	echo "Docker installed!"
			
	else	
		echo "Docker already installed... proceding..."

	fi

}

function dockerComposeInstall() {
	
	if ! command -v docker-compose &> /dev/null
	then
        	curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        	chmod +x /usr/local/bin/docker-compose
        	ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
        	docker-compose -v
 		echo "Docker Compose installed!"
	else
		echo "Docker compose is already installed..."
		echo "Exiting..."
	fi

}

if ! command -v lsb_release $> /dev/null
then
	DISTRO=`lsb_release -i | cut -f 2-`
	if [[ $DISTRO == Kali ]];then
		echo "Kali Linux intallation"
		printf '%s\n' "deb https://download.docker.com/linux/debian bullseye stable"
		tee /etc/apt/sources.list.d/docker-ce.list
		curlTry
		curl -fsSL https://download.docker.com/linux/debian/gpg
		gpg --dearmor -o /etc/apt/trusted.gpg.d/docker-ce-archive-keyring.gpg
		apt update 
		apt install -y docker docker-ce docker-ce-cli containerd.io docker-compose 

	if [[ $DISTRO == Debian]] || [[$DISTRO = Ubuntu]] || [[$DISTRO = Red Hat ]] || [[$DISTRO = CentOS ]];then
		echo "Debian Linux installation"
		curlTry
		dockerInstall
		dockerComposeInstall
		
	fi

	if [[ $DISTRO == OracleServer ]];then
		echo "not enable to insall docker yet"

else
	echo "command lsb_release not found... please install..."
	exit 1
fi

