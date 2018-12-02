.PHONY: run serve
run serve: kill assets
	cobalt serve --drafts

.PHONY: build
build: clean assets
	cobalt build
	# Open external links in separate tab
	find build -type f -name "*.html" | xargs sed -i '' 's/<a href="http/<a target="_blank" rel="noopener" href="http/g'
	# Setup symlinks
	touch .nojekyll

.PHONY: clean
clean:
	rm -rf build/

.PHONY: lqip
lqip:
	lqip

.PHONY: css assets
css assets:
	sass assets/main.scss assets/main.css --style compressed --no-source-map

.PHONY: deploy
deploy: build
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

.PHONY: kill
kill:
	killall -9 cobalt || exit 0

.PHONY: watch
watch: kill
	cobalt serve --drafts &
	fswatch -0 blog _drafts | xargs -0 -n1 sh -c 'cobalt build --drafts'

.PHONY: watch-interactive
watch-interactive: kill
	cobalt serve --drafts &
	fswatch -0 blog _drafts | xargs -0 -n1 sh -c 'cobalt build --drafts && osascript refresh-firefox.scpt'
