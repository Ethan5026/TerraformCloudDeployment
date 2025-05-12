#!/bin/bash

# Update packages and install dependencies
apt-get update
apt-get install -y curl git mysql-client

# Install Node.js (v18)
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt-get install -y nodejs

# Clone Node.js app from GitHub
git clone https://github.com/Ethan5026/TerraformCloudDeployment.git /opt/app
cd /opt/app

# Install Node.js dependencies
npm install


# Initialize MySQL schema (optional)
if [ -f "init.sql" ]; then
  mysql -h 127.0.0.1 -u "nodeuser" -p "nodepassword" "nodedb" < init.sql
fi

# Create systemd service to auto-restart Node.js app
cat <<EOF > /etc/systemd/system/nodeapp.service
[Unit]
Description=Node.js App
After=network.target

[Service]
WorkingDirectory=/opt/app
ExecStart=/usr/bin/node /opt/app/serverv5.js
Restart=always
RestartSec=10
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=nodeapp

[Install]
WantedBy=multi-user.target
EOF

# Enable and start the service
systemctl daemon-reexec
systemctl daemon-reload
systemctl enable nodeapp
systemctl start nodeapp
