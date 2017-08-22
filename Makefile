.PHONY: build clean css

build: assets
	rm -rf build/
	cobalt build
	# Setup symlinks
	touch .nojekyll
.PHONY: build

css assets:
	sass assets/main.scss:assets/main.css --style compressed --no-cache
.PHONY: css assets

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
.PHONY: publish

serve: assets
	cobalt serve
.PHONY: serve
