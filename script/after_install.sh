#!/bin/bash

RED='\033[0;31m'
NC='\033[0m'
RELEASE_FOLDER=$(date '+%Y%m%d%H%M%S')

# cd /home/deploy/blog-cloud

# echo -e "${RED}execute ls"
# echo $(ls)

# 1 update shared file, folder
if ! [ -d /var/www/rails_app/shared ]; then
  mkdir -p /var/www/rails_app/shared
  mkdir -p /var/www/rails_app/shared/bundle
fi

aws s3 cp s3://blog-cloud-codedeploy/.env /var/www/rails_app/shared
aws s3 cp s3://blog-cloud-codedeploy/credentials.yml.enc /var/www/rails_app/shared
aws s3 cp s3://blog-cloud-codedeploy/puma.rb /var/www/rails_app/shared


# 2 Create release folder

mkdir -p /var/www/rails_app/releases/$RELEASE_FOLDER
cp -R /home/deploy/blog-cloud/* /var/www/rails_app/releases/$RELEASE_FOLDER


# 3
if [ -d /var/www/rails_app/releases/$RELEASE_FOLDER/log ]; then
  rm -rf /var/www/rails_app/releases/$RELEASE_FOLDER/log/*
fi

if [ -f /var/www/rails_app/releases/$RELEASE_FOLDER/config/credentials.yml.enc ]; then
  rm /var/www/rails_app/releases/$RELEASE_FOLDER/config/credentials.yml.enc
end

if [ -f /var/www/rails_app/releases/$RELEASE_FOLDER/config/puma.rb ]; then
  rm /var/www/rails_app/releases/$RELEASE_FOLDER/config/puma.rb
end

ln -s /var/www/rails_app/shared/.env /var/www/rails_app/releases/$RELEASE_FOLDER/

ln -s /var/www/rails_app/shared/credentials.yml.enc /var/www/rails_app/releases/$RELEASE_FOLDER/config

ln -s /var/www/rails_app/shared/puma.rb /var/www/rails_app/releases/$RELEASE_FOLDER/puma.rb

ln -s /var/www/rails_app/shared/bundle /var/www/rails_app/releases/$RELEASE_FOLDER/vendor/bundle


# 4 bundle

bundle install --path=vendor/bundle
bundle exec rake db:create
bundle exec rake db:migrate

# 5 Link to shared folder

ln -s /var/www/rails_app/releases/$RELEASE_FOLDER /var/www/rails_app/releases/current
mv /var/www/rails_app/releases/current /var/www/rails_app/

# restart nginx
sudo service puma restart
sudo service nginx restart