#!/usr/bin/env bash

source .env

# Build site locally
rm -rf _site
bundle exec jekyll build \
  --config "_config.yml,_config.dat.yml"

# Clean remote archive directory
ssh $DAT_DEPLOY_USER@$DAT_DEPLOY_HOST <<ENDSSH
cd $DAT_DEPLOY_PATH
# Delete all files except .dat directory
ls . | grep -v '.dat' | xargs rm -rf
ENDSSH

# Sync local build to remote archive
rsync -av ./_site/ $DAT_DEPLOY_USER@$DAT_DEPLOY_HOST:$DAT_DEPLOY_PATH/
