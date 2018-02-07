#!/usr/bin/env bash

source .env

git pull

# Build site locally
rm -rf $DAT_PATH 

bundle exec jekyll build \
  --config "_config.yml,_config.dat.yml" \
  --destination $BUILD_PATH

# Link to keys
ln -s $DAT_PATH $BUILD_PATH/ 

# Publish changes
dat share --directory=$DAT_PATH
