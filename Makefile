deploy : build
	_scripts/deploy.sh

build : clean build_jekyll build_css

build_css :  
	./node_modules/.bin/postcss ./static/css/**/*.css \
		--base ./static/css \
		--dir _site/static/css

build_jekyll :
	bundle exec jekyll build \
		--config "_config.yml,_config.maxhallinan.com.yml"

clean :
	rm -rf _site

install : 
	yarn install 
