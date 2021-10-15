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
	
	if ! command -v docker &> /dev/null
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

curlTry
dockerInstall
dockerComposeInstall
