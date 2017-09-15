clean:
	rm -rf build/

lqip:
	lqip
.PHONY: lqip

build: clean assets
	cobalt build
	# Setup symlinks
	touch .nojekyll
.PHONY: build

css assets:
	sass assets/main.scss:assets/main.css --style compressed --no-cache --sourcemap=none
.PHONY: css assets

publish: build
	git branch -Dq master
	cobalt import --branch master
	sleep 1
	git checkout master
	minify -r -o minified/ .
	cp -Rf minified/* .
	rm -rf minified/
	rm minify.conf
	touch .nojekyll
	rm -rf build/
	git add .
	git commit -m 'New deploy!'
	git push -u -f origin master
	git checkout source
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
