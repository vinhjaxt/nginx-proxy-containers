#!/usr/bin/env sh
chown user:user /home/shared_socket -R
cd /opt/app
su user -c 'node /opt/app/app.js'
