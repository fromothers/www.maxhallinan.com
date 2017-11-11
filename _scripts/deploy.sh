echo "Building site locally...\n"
rm -rf _site
jekyll build \
  --config "_config.yml,_config.maxhallinan.com.yml"

# echo "\n\nCompressing the files...\n"
# for i in `find ./_site | grep -E "\.html$|\.css$|\.js$|\.json|\.xml$"`;
#   do gzip --verbose "$i"; \
#   mv "$i.gz" "$i"; 
# done

echo "\n\nSyncing images and fonts...\n"
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

echo "\n\nSyncing html...\n"
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

echo "\n\nSyncing css...\n"
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

echo "\n\nSyncing js...\n"
s3cmd sync \
  --acl-public \
  --no-preserve \
  --exclude "*.*" \
  --add-header="Cache-Control:public, max-age=604800" \
  --mime-type="application/javascript" \
  --include "*.js" \
  -c .s3cmd \
  _site/ s3://maxhallinan.com

echo "\n\nSyncing json...\n"
s3cmd sync \
  --acl-public \
  --no-preserve \
  --exclude "*.*" \
  --add-header="Cache-Control:public, max-age=86400, must-revalidate" \
  --mime-type="application/json" \
  --include "*.json" \
  -c .s3cmd \
  _site/ s3://maxhallinan.com

echo "\n\nSyncing xml...\n"
s3cmd sync \
  --acl-public \
  --no-preserve \
  --exclude "*.*" \
  --add-header="Cache-Control:public, max-age=2629800" \
  --mime-type="application/xml" \
  --include "*.xml" \
  -c .s3cmd \
  _site/ s3://maxhallinan.com

echo "\n\nOverwriting index.html with short expires time...\n"
s3cmd put \
  --acl-public \
  --no-preserve \
  --add-header="Cache-Control:public, max-age=86400, must-revalidate" \
  --add-header="Expires:access plus 1 day"  \
  --mime-type="text/html; charset=utf-8" \
  -c .s3cmd \
  _site/index.html s3://maxhallinan.com

echo "\n\nSyncing remaining and cleaning up...\n"
s3cmd sync \
  --acl-public \
  --no-preserve \
  --delete-removed \
  -c .s3cmd \
  _site/ s3://maxhallinan.com
