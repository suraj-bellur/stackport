# adding repository and installing nginx		
apt update
apt install nginx -y
cat <<EOT > stackportapp
upstream stackportapp {

 server app01:8080;

}

server {

  listen 80;

location / {

  proxy_pass http://stackportapp;

}

}

EOT

mv stackportapp /etc/nginx/sites-available/stackportapp
rm -rf /etc/nginx/sites-enabled/default
ln -s /etc/nginx/sites-available/stackportapp /etc/nginx/sites-enabled/stackportapp

#starting nginx service and firewall
systemctl start nginx
systemctl enable nginx
systemctl restart nginx
