#!/usr/bin/env bash

source .env

ssh $DAT_REMOTE_USER@$DAT_REMOTE_HOST \
  "cd $DAT_REMOTE_PATH; _scripts/deploy-dat.sh"
