extends: default.liquid

title:      Making Myself Obsolete
subtitle:   Writing a Linter for Linting Linters
date:       27 Nov 2017 00:00:00 +0000
humandate:  27th of November 2017
path:       2017/obsolete
---

<figure>
        <object data="/img/posts/2017/obsolete/dinosaur.svg" type="image/svg+xml"></object>
  <figcaption>
  The Stegosaurus had better days 150 million years ago.<br />
  Paleontologists once thought he had a <a href="https://en.wikipedia.org/wiki/Stegosaurus#.22Second_brain.22">brain in its butt</a>.
  </figcaption>
</figure>

In December 2015 I was looking for static analysis tools to integrate into trivago's CI process.
The idea was to detect typical programming mistakes automatically.
That's quite a common thing and there are lots of helpful tools out there which fit the bill.

So I looked for a list of tools...

To my surprise, [the only list I found was on Wikipedia](https://en.wikipedia.org/wiki/List_of_tools_for_static_code_analysis) &mdash; and it was a bit outdated.
There was no such project on Github, where most modern static analysis tools were hosted.

Without thinking too much about it, I opened up my editor and wrote down a few tools I found through my initial research. After that, I pushed the list to Github.  

Fast forward two years, and the list has grown quite a bit.
So far, it has 65 contributors, 261 forks and received 2000 stars. (Thanks for all support!)

The project has become an important source of information for many people.
Around 1000 unique visitors find the list every week. It's not much by any means, but I feel obliged to keep it up-to date.

There was one problem though: The list of pull requests got longer and longer as I was busy doing other things.

### Adding contributors

I always try to give admin rights to regular contributors. My colleague and friend [Andy Grunwald](https://github.com/andygrunwald) as well as [Ouroboros Chrysopoeia](https://github.com/impredicative) are both valuable collaborators. They help me weed out new PRs whenever they have time.

But let's face it: checking the pull requests is boring, manual work.
What needs to be done can be summarized in a checklist:

* Formatting rules are satisfied
* Project URL is reachable
* License annotation is correct
* Tools of each section are alphabetically ordered

I guess it's obvious what we should do with that checklist: automate it!

### A linter for linting linters

So why not write an analysis tool, which checks our list of analyis tools!
What sounds pretty meta, is actually pretty straightforward.

With every pull request, we trigger our bot, which checks the above rules and responds with a result.

Github documentation: https://developer.github.com/v3/guides/building-a-ci-server/