#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <admin_email>"
    exit 1
fi

ADMIN_EMAIL=$1
REP_FLASK=/opt/portfolio
SITE_NGINX=portfolio
PORTFOLIO_DOMAIN=portfolio.syllab.com

# Paquets
sudo apt update && sudo apt upgrade -y
sudo apt install -y python3 python3-pip python3-venv nginx

# Application
python3 -m venv $REP_FLASK/venv
source $REP_FLASK/venv/bin/activate
pip install -r $REP_FLASK/requirements.txt

# Gunicorn
sudo tee /etc/systemd/system/gunicorn.service > /dev/null <<EOT
[Unit]
Description=gunicorn daemon
After=network.target

[Service]
User=www-data
Group=www-data
WorkingDirectory=$REP_FLASK
ExecStart=$REP_FLASK/venv/bin/gunicorn --workers 3 --bind unix:$REP_FLASK/app.sock deploy.wsgi:app

[Install]
WantedBy=multi-user.target
EOT

sudo systemctl start gunicorn
sudo systemctl enable gunicorn

# Nginx
sudo tee /etc/nginx/sites-available/$SITE_NGINX > /dev/null <<EOT
server {
    listen 80;
    server_name $PORTFOLIO_DOMAINE;

    location / {
        proxy_pass http://unix:$REP_FLASK/app.sock;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOT

sudo ln -s /etc/nginx/sites-available/$SITE_NGINX /etc/nginx/sites-enabled
sudo nginx -t
sudo systemctl restart nginx

# Configuration
SECRET_KEY=$(openssl rand -base64 32)
CSRF_SECRET=$(openssl rand -base64 32)
SECURITY_PASSWORD_SALT=$(openssl rand -base64 32)
JWT_SECRET_KEY=$(openssl rand -base64 32)

mkdir -p $REP_FLASK/instance

cp $REP_FLASK/deploy/config.py $REP_FLASK/instance/config.py

sed -i "s/^ADMIN_MAIL = .*$/ADMIN_MAIL = '$ADMIN_EMAIL'/" $REP_FLASK/instance/config.py
sed -i "s/^SECRET_KEY = .*$/SECRET_KEY = '$SECRET_KEY'/" $REP_FLASK/instance/config.py
sed -i "s/^CSRF_SECRET = .*$/CSRF_SECRET = '$CSRF_SECRET'/" $REP_FLASK/instance/config.py
sed -i "s/^SECURITY_PASSWORD_SALT = .*$/SECURITY_PASSWORD_SALT = '$SECURITY_PASSWORD_SALT'/" $REP_FLASK/instance/config.py
sed -i "s/^JWT_SECRET_KEY = .*$/JWT_SECRET_KEY = '$JWT_SECRET_KEY'/" $REP_FLASK/instance/config.py

ADMIN_PASSWORD=$(openssl rand -base64 12)

cd $REP_FLASK
flask users change_password $ADMIN_EMAIL --password $ADMIN_PASSWORD

# Fin
echo "Installation terminée !"
echo "Admin : $ADMIN_EMAIL / $ADMIN_PASSWORD"
