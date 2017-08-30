clean:
	rm -rf build/

build: clean assets
	cobalt build
	# Setup symlinks
	touch .nojekyll
.PHONY: build

css assets:
	sass assets/main.scss:assets/main.css --style compressed --no-cache --sourcemap=none
.PHONY: css assets

publish-old: clean
	-git branch -D master
	cobalt build
	cobalt import --branch master
	git checkout master
	touch .nojekyll
	git add .nojekyll
	git commit -m "Github Pages integration"
	git push -u -f origin master
	git checkout source
.PHONY: publish-old

publish: clean build
	minify -r -o minified/ build
	cp -Rf minified/* build/.
	rm -rf minified/
	rm build/minify.conf
	touch build/.nojekyll
	git branch -Dq master
	git branch master HEAD
	git filter-branch --subdirectory-filter build -- master
.PHONY: publish

kill:
	killall -9 cobalt || exit 0

serve: kill assets
	cobalt serve
.PHONY: serve

watch: kill
	cobalt serve --drafts &
	fswatch -0 blog _drafts | xargs -0 -n1 sh -c 'cobalt build --drafts'
.PHONY: watch

watch-interactive: kill
	cobalt serve --drafts &
	fswatch -0 blog _drafts | xargs -0 -n1 sh -c 'cobalt build --drafts && osascript refresh-firefox.scpt'
.PHONY: watch-interactive
