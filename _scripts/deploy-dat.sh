#!/usr/bin/env bash

# Load environemnt for .ssh commands
source .env

git pull

# Build site locally
rm -rf $BUILD_PATH

bundle exec jekyll build \
  --config "_config.yml,_config.dat.yml" \
  --destination $BUILD_PATH

# Link to keys
ln -s $DAT_PATH $BUILD_PATH/

# Publish changes
dat share --dir $BUILD_PATH
