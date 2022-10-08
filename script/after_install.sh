#!/bin/bash

cd /home/deploy/blog-cloud

echo $(ls)

# aws s3 cp s3://blog-cloud-codedeploy/.env ./
# aws s3 cp s3://blog-cloud-codedeploy/credentials.yml.enc ./config
# aws s3 cp s3://blog-cloud-codedeploy/puma.rb ./config

# RELEASE_FOLDER=$(date '+%Y%m%d%H%M%S')

# mkdir /var/www/rails_app/releases/$RELEASE_FOLDER
# cp -R /home/deploy/blog-cloud/* /var/www/rails_app/releases/$RELEASE_FOLDER


# ln -s /var/www/rails_app/releases/$RELEASE_FOLDER /var/www/rails_app/releases/current
# mv /var/www/rails_app/releases/current /var/www/rails_app/

# restart nginx