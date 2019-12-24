#!/bin/bash

# Install newest AWS CLI. Apt has old version.
sudo apt-get update
sudo apt-get -y install python-pip
pip install awscli --upgrade --user

# Default profile must exist before it can be referenced. Need to set this file here because it
# uses env vars, not terraform vars.
echo '[default]' > ~/.aws/credentials
echo "AWS_ACCESS_KEY_ID = $AWS_ACCESS_KEY_ID" >> ~/.aws/credentials
echo "AWS_SECRET_ACCESS_KEY = $AWS_SECRET_ACCESS_KEY" >> ~/.aws/credentials

# where are we executing(debug)
echo -n "executing in account number: "
~/.local/bin/aws sts get-caller-identity --output text --query 'Account' --profile master_payer

~/.local/bin/aws ram enable-sharing-with-aws-organization --profile master_payer

