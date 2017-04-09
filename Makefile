.PHONY: build clean css

build: css
	rm -rf build/
	cobalt build
	# Setup symlinks
	touch .nojekyll

css:
	sass assets/main.scss:assets/main.css --style compressed --no-cache

publish:
	-git branch -D master
	rm -rf build/
	cobalt build
	cobalt import --branch master
	git checkout master
	touch .nojekyll
	git add .nojekyll
	git commit -m "Github Pages integration"
	git push -u -f origin master
	git checkout source

serve:
	cobalt serve
