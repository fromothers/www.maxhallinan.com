deploy : build
	_scripts/deploy.sh

build : clean build_jekyll build_css

build_css : clean_css
	./node_modules/.bin/postcss ./static/css/styles.css \
		--output _site/static/css/styles.css

build_jekyll :
	JEKYLL_ENV="production" bundle exec jekyll build \
		--config "_config.yml,_config.maxhallinan.com.yml"

clean :
	rm -rf _site

clean_css :
	rm -rf _site/static/css

install :
	yarn install

watch_jekyll :
	bundle exec jekyll serve --watch --drafts
