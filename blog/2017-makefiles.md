extends: default.liquid

title:      Afraid of Makefiles? Don't be!
date:       15 Aug 2017 00:00:00 +0000
humandate:  15th of August 2017
path:       2017/makefiles
---

<figure>
  <img src="/img/posts/2017/make/clothes.svg" alt="Different clothes on a hanging rail.">
  <figcaption>
  What do clothes have to do with Makefiles? Find out in this post.
  <a href="http://www.freepik.com/free-photos-vectors/background">Background vector created by Anindyanfitri - Freepik.com</a>
  </figcaption>
</figure

In the last few years, I've had the pleasure to work with a lot of talented Software Engineers.
One thing that struck me is, that many of them did not have any working knowledge of `Makefiles` 
and why they are useful.

When faced with the task to automate a build process, they roll their own shell scripts.
Common filenames are `build.sh` or `run.sh` or `doall.sh` etc.  

They implement the same basic funtionality over and over again:

* Parsing input parameters and environment variables
* Manually managing dependencies between build steps.
* Maybe error handling

That's a lot of work. Along the way, they keep doing the same basic mistakes:

* Incorrectly handling input parameters and [environment variables](https://en.wikipedia.org/wiki/Shellshock_(software_bug)).
* Missing dependencies between each build step.
* [Forgetting to handle errors](http://www.davidpashley.com/articles/writing-robust-shell-scripts/) and &mdash; even worse &mdash; carrying on with the program execution.

### Makefiles are scary!

If you think that `make` is scary, you probably think of complicated machinery for big software projects.
It doesn't need to be this way. Let's hear what the author of `make`, [Stuart Feldman](https://en.wikipedia.org/wiki/Stuart_Feldman) has to say:

> It began with an elaborate idea of a dependency analyzer, boiled down to something much simpler, and turned into Make that weekend. Use of tools that were still wet was part of the culture. Makefiles were text files, not magically encoded binaries, because **that was the Unix ethos: printable, debuggable, understandable stuff.**  
>
> &mdash; [The Art of Unix Programming (2003)](http://nakamotoinstitute.org/static/docs/taoup.pdf)

### Makefiles are simple!

Before I leave the house, I need to get dressed.
I use the same simple routine every time:
Underpants, trousers, shirt, pullover, jacket, socks, shoes.
Most likeley you also have a routine, even though it might be different.

Some of these steps depend on each other.  
`Make` is good for handling dependencies.  
Let's try to express my routine as a `Makefile`.

```make
dress: shoes jacket
	@echo "All done! Let's go outside."

pullover: shirt
	@echo "Putting on pullover."

shirt:
	@echo "Putting on shirt."

trousers: underpants
	@echo "Putting on trousers."

underpants:
	@echo "Putting on underpants."

jacket: pullover
	@echo "Putting on jacket."

shoes: socks trousers
	@echo "Putting on shoes."

socks:
	@echo "Putting on socks."
```

If we execute the `Makefile`, we get the following output:

```
$ make
Putting on underpants.
Putting on trousers.
Putting on shirt.
Putting on pullover.
Putting on jacket.
Putting on socks.
Putting on shoes.
All done! Let's go outside.
```

### What just happened?

Noticed how the steps are in the correct order?
By plainly writing down the dependencies between the steps, `make` helps us keep them in order.

Each build steps has the following structure:

```make
target: [dependencies]
	<shell command to execute>
	<shell command to execute>
	...
```

The first command in a `Makefile` will be executed by default when we all `make`.
That's it! You've learned 90% of what you need to know about `make`.

### Next steps

Real `Makefiles` can do even more! They will [only build the files that have changed](https://stackoverflow.com/a/3798609/270334) instead of doing a full rebuild.
And they will do [as much as possible in parallel](https://stackoverflow.com/a/3841803/270334).

If I've convinced you that `make` is awesome, keep on [reading here](https://learnxinyminutes.com/docs/make/).


