#!/bin/bash

set -e
set -x

RED='\033[0;31m'
NC='\033[0m'
RELEASE_FOLDER=$(date '+%Y%m%d%H%M%S')

echo -e "${RED}After Install${NC}"
echo -e "---------${RED}whoami: $(whoami)${NC}--------"
# echo $(ls)

sudo chown -R deploy:deploy /home/deploy/blog-cloud

# 1 update shared file, folder
if ! [ -d /var/www/rails_app/shared ]; then
  mkdir -p /var/www/rails_app/shared
  mkdir -p /var/www/rails_app/shared/bundle
  mkdir -p /var/www/rails_app/shared/log
  mkdir -p /var/www/rails_app/shared/config
  mkdir -p /var/www/rails_app/shared/tmp
  mkdir -p /var/www/rails_app/shared/tmp/pids
  mkdir -p /var/www/rails_app/shared/tmp/socke
fi

aws s3 cp s3://blog-cloud-codedeploy/.env /var/www/rails_app/shared
aws s3 cp s3://blog-cloud-codedeploy/master.key /var/www/rails_app/shared/config
aws s3 cp s3://blog-cloud-codedeploy/credentials.yml.enc /var/www/rails_app/shared/config
aws s3 cp s3://blog-cloud-codedeploy/puma.rb /var/www/rails_app/shared/config

# 2 Create release folder

mkdir -p /var/www/rails_app/releases/$RELEASE_FOLDER
cp -r /home/deploy/blog-cloud/* /var/www/rails_app/releases/$RELEASE_FOLDER

# 3
if [ -d /var/www/rails_app/releases/$RELEASE_FOLDER/log ]; then
  rm -rf /var/www/rails_app/releases/$RELEASE_FOLDER/log
fi

if [ -f /var/www/rails_app/releases/$RELEASE_FOLDER/config/credentials.yml.enc ]; then
  rm /var/www/rails_app/releases/$RELEASE_FOLDER/config/credentials.yml.enc
fi

if [ -f /var/www/rails_app/releases/$RELEASE_FOLDER/config/puma.rb ]; then
  rm /var/www/rails_app/releases/$RELEASE_FOLDER/config/puma.rb
fi

ln -s /var/www/rails_app/shared/.env /var/www/rails_app/releases/$RELEASE_FOLDER/
ln -s /var/www/rails_app/shared/bundle /var/www/rails_app/releases/$RELEASE_FOLDER/vendor/bundle
ln -s /var/www/rails_app/shared/config/master.key /var/www/rails_app/releases/$RELEASE_FOLDER/config
ln -s /var/www/rails_app/shared/config/credentials.yml.enc /var/www/rails_app/releases/$RELEASE_FOLDER/config
ln -s /var/www/rails_app/shared/config/puma.rb /var/www/rails_app/releases/$RELEASE_FOLDER/config
ln -s /var/www/rails_app/shared/log /var/www/rails_app/releases/$RELEASE_FOLDER/log

# 4 bundle
cd /var/www/rails_app/releases/$RELEASE_FOLDER
RAILS_ENV=production /home/deploy/.rbenv/shims/bundle install --path=vendor/bundle
RAILS_ENV=production /home/deploy/.rbenv/shims/bundle exec rake db:create
RAILS_ENV=production /home/deploy/.rbenv/shims/bundle exec rake db:migrate

# 5 Link to shared folder

ln -s /var/www/rails_app/releases/$RELEASE_FOLDER /var/www/rails_app/releases/current
mv -f /var/www/rails_app/releases/current /var/www/rails_app/

sudo chown -R deploy:deploy /var/www/rails_app/

# restart nginx
sudo systemctl daemon-reload
sudo service puma restart
sudo service nginx restart