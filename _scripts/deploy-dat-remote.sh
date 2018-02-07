#!/usr/bin/env bash

source .env

ssh $REMOTE_DAT_USER@$REMOTE_DAT_HOST -t \
  "source ~/.zshrc; cd $REMOTE_DAT_PATH; _scripts/deploy-dat.sh"
