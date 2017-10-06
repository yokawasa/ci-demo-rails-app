#!/usr/bin/env bash

## Start SSHD
service ssh start

touch /home/LogFiles/node_${WEBSITE_ROLE_INSTANCE_ID}_out.log
echo "$(date) Container started" >> /home/LogFiles/node_${WEBSITE_ROLE_INSTANCE_ID}_out.log

# Running Puma
echo "Running Puma"
#bundle exec puma -d
bundle exec puma -C config/puma.rb -b tcp://0.0.0.0:3000 -b unix:///myapp/tmp/puma.sock -d

# Running Nginx(Foreground)
echo "Running NGINX (Foreground) "
/usr/sbin/nginx -g 'daemon off;' -c /etc/nginx/nginx.conf
