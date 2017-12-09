#!/usr/bin/env bash

echo "Building site locally..."
pwd
rm -rf _site
bundle exec jekyll build \
  --config "_config.yml,_config.maxhallinan.com.yml"

# echo "Compressing the files..."
# for i in `find ./_site | grep -E "\.html$|\.css$|\.js$|\.json|\.xml$"`;
#   do gzip --verbose "$i"; \
#   mv "$i.gz" "$i"; 
# done

echo "Syncing images and fonts..."
s3cmd sync \
  --acl-public \
  --no-preserve \
  --exclude "*.*" \
  --add-header="Cache-Control:public, max-age=31557600" \
  --include "*.png" \
  --include "*.jpg" \
  --include "*.gif" \
  --include "*.ico" \
  --include "*.eot" \
  --include "*.svg" \
  --include "*.ttf" \
  --include "*.woff" \
  --include "*.otf" \
  -c .s3cmd \
  _site/ s3://maxhallinan.com

echo "Syncing html..."
s3cmd put \
  --acl-public \
  --no-preserve \
  --recursive \
  --exclude "*.*" \
  --add-header="Cache-Control:public, max-age=604800" \
  --mime-type="text/html" \
  --include "*.html" \
  -c .s3cmd \
  _site/ s3://maxhallinan.com

echo "Syncing css..."
s3cmd put \
  --acl-public \
  --no-preserve \
  --recursive \
  --exclude "*.*" \
  --add-header="Cache-Control:public, max-age=604800" \
  --mime-type="text/css" \
  --include "*.css" \
  -c .s3cmd \
  _site/ s3://maxhallinan.com

echo "Syncing js..."
s3cmd sync \
  --acl-public \
  --no-preserve \
  --exclude "*.*" \
  --add-header="Cache-Control:public, max-age=604800" \
  --mime-type="application/javascript" \
  --include "*.js" \
  -c .s3cmd \
  _site/ s3://maxhallinan.com

echo "Syncing json..."
s3cmd sync \
  --acl-public \
  --no-preserve \
  --exclude "*.*" \
  --add-header="Cache-Control:public, max-age=86400, must-revalidate" \
  --mime-type="application/json" \
  --include "*.json" \
  -c .s3cmd \
  _site/ s3://maxhallinan.com

echo "Syncing xml..."
s3cmd sync \
  --acl-public \
  --no-preserve \
  --exclude "*.*" \
  --add-header="Cache-Control:public, max-age=2629800" \
  --mime-type="application/xml" \
  --include "*.xml" \
  -c .s3cmd \
  _site/ s3://maxhallinan.com

echo "Overwriting index.html with short expires time..."
s3cmd put \
  --acl-public \
  --no-preserve \
  --add-header="Cache-Control:public, max-age=86400, must-revalidate" \
  --add-header="Expires:access plus 1 day"  \
  --mime-type="text/html; charset=utf-8" \
  -c .s3cmd \
  _site/index.html s3://maxhallinan.com

echo "Syncing remaining and cleaning up..."
s3cmd sync \
  --acl-public \
  --no-preserve \
  --delete-removed \
  -c .s3cmd \
  _site/ s3://maxhallinan.com
