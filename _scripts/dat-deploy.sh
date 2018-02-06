#!/usr/bin/env bash

# Build site locally
rm -rf _site
bundle exec jekyll build \
  --config "_config.yml,_config.dat.yml"

# Move these definitons to the environment to environment
DAT_DEPLOY_USER=max
DAT_DEPLOY_HOST=138.197.103.47
DAT_DEPLOY_PATH=/home/max/foo

# Clean remote archive directory
ssh $DAT_DEPLOY_USER@$DAT_DEPLOY_HOST <<ENDSSH
cd $DAT_DEPLOY_PATH
# Delete all files except .dat directory
ls . | grep -v '.dat' | xargs rm
ENDSSH

# Sync local build to remote archive
rsync -a ./_site $DAT_DEPLOY_USER@$DAT_DEPLOY_HOST:$DAT_DEPLOY_PATH

# Share changes
ssh $DAT_DEPLOY_USER@$DAT_DEPLOY_HOST <<'ENDSSH'
cd $DAT_DEPLOY_PATH
dat share
ENDSSH
