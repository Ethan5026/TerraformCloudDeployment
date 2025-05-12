#!/bin/bash
apt-get update
apt-get install -y curl git

curl -sL https://deb.nodesource.com/setup_18.x | bash -
apt-get install -y nodejs

git clone https://github.com/YOUR_REPO_URL/app.git /opt/app
cd /opt/app

npm install
npm start &