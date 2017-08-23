analytics:
	curl -o assets/analytics.js https://www.google-analytics.com/analytics.js
.PHONY: analytics

build: assets analytics
	rm -rf build/
	cobalt build
	# Setup symlinks
	touch .nojekyll
.PHONY: build

css assets:
	sass assets/main.scss:assets/main.css --style compressed --no-cache --sourcemap=none
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
