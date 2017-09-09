extends: default.liquid

title:      Afraid of Makefiles? Don't be!
date:       15 Aug 2017 00:00:00 +0000
humandate:  15th of August 2017
path:       2017/makefiles
excerpt:    In the last few years, I've had the pleasure to work with a lot of talented Software Engineers.
            One thing that struck me is, that many of them did not have any working knowledge of `Makefiles` 
            and why they are useful. Let's change that!
social_img: 2017_makefiles.png
comments: 
  - <a href="https://news.ycombinator.com/item?id=15041986">Hacker News</a>
  - <a href="https://www.reddit.com/r/programming/comments/6u2yen/afraid_of_makefiles_dont_be/">Reddit</a>
  - <a href="https://lobste.rs/s/rkxbue/afraid_makefiles_dont_be">Lobsters</a>
---

<figure>
  <div class="loader">
    <img src="/img/posts/2017/make/clothes.svg" alt="Different clothes on a hanging rail.">
    <img class="frozen" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAB4AAAAOCAMAAAAPOFwLAAACJVBMVEX////39/jf3+Da2tvb29zb293Z2drf4OHR3+J/nKW/0dTRz83Jx8PRz87IxsLV1NLx5Mvp4tX58uPq4tTWxKfRwKXXxqjw6+HN5/Pr6+vO5/HuxsXMfXvCd3fVnp25yNDo6Omvwsv4+vv8/f1amKwNXHpBe40SX3x+f32EfXd3cGyFfXfWs2f6ylP5zWf7y1HFpWqQayeVcC6ObC1Bos4imdVivOVff6WuSVDIWVa8WVeMUloVTWqGpLQNSmno7vF/t8cphJ4LW3kbcY2WmJKqnpOWjITyvkj7yUnKnEW8izK1hjBqlIkfl9QfldMjn9q7XFvERUHIZGO7WFdRTV8ZVG+dtsJwr8E1iqMSXnqpnpOsoJa7pYDyvEPBkTa6ijJ6k3k+msMekM8ol9HiWEq8UlPDTky8ODYwTGYpYnhvk6aTtsQtaX7Y087NrWz6x0i6iTLWuIKBnYsgmNVve5jaV0y0ZW1+qLg2Znd5enialI39/f3MqFvsukfwwEe6iTG+jzn07N57knsgl9ShZnGrYGexYmnLZWTIWlkvS2Vqm61IhJv1zXP3y2TktEPNpmDClUR5kHcjk9DFW1h9b4iuWmKCPkearLiLUlectMHF1Nvs8vTD1t6av8y909vl7vH53qL96Ln1zHLXrVXcv4nSsHTo28L66+r++vr03t7w09P45uX//v7Ut4Pr3MHgyaDfy6Xx6Nbizaf48+ry6djk0a317+PGZJKPAAAAu0lEQVR42o3JJVAFUQBG4fM/d3+7iYI2HPrgUHHpWEF7H7Rn3PvQAw3tdaUX3N2+6/d4+dUfWRLoFjw3T8t7/fr2XfkFhPQjH0XSb7lA0q3nccH7ZGPeZ/PxdPKSA3k39y7n5GEzC1mHTAYoy5Cx0w94cI4PYvezVlLSIal6kdK9tHQBDzkLR+2zzAtSh82Ty3pwQkW/JB+kByRBTgOIPPnVIUmN0LOtLj7Y7dhjv+OAVz7e840I/7j4rzsRdiQdQgYtsgAAAABJRU5ErkJggg" />
  </div
  <figcaption>
  What do clothes have to do with Makefiles? Find out in this post.
  <a href="http://www.freepik.com/free-photos-vectors/background">Background vector created by Anindyanfitri - Freepik.com</a>
  </figcaption>
</figure

In the last few years, I've had the pleasure to work with a lot of talented Software Engineers.
One thing that struck me is, that many of them did not have any working knowledge of `Makefiles` 
and why they are useful.

When faced with the task to automate a build process, they often roll their own shell scripts.
Common culprits are called `build.sh` or `run.sh` or `doall.sh` etc.  

They implement the same basic functionality over and over again:

* Parsing input parameters and environment variables.
* Manually managing dependencies between build steps.
* Error handling... maybe.

Along the way, they keep doing the same basic mistakes:

* Incorrectly handling [input parameters](http://www.pixelbeat.org/programming/shell_script_mistakes.html) and [environment variables](https://en.wikipedia.org/wiki/Shellshock_(software_bug)).
* Missing dependencies between build steps.
* [Forgetting to handle errors](http://www.davidpashley.com/articles/writing-robust-shell-scripts/) and &mdash; even worse &mdash; carrying on with the program execution.

### Makefiles are scary!

If you think that `make` is scary, you probably think of complicated build machinery for [big](https://community.kde.org/Guidelines_and_HOWTOs/Build_from_source) [software](https://chromium.googlesource.com/chromium/src/+/lkcr/docs/linux_build_instructions.md) projects.
It doesn't need to be that way. Let's hear what the author of `make`, [Stuart Feldman](https://en.wikipedia.org/wiki/Stuart_Feldman) has to say:

> It began with an elaborate idea of a dependency analyzer, boiled down to something much simpler, and turned into Make that weekend. Use of tools that were still wet was part of the culture. Makefiles were text files, not magically encoded binaries, because **that was the Unix ethos: printable, debuggable, understandable stuff.**  
>
> &mdash; [The Art of Unix Programming (2003)](http://nakamotoinstitute.org/static/docs/taoup.pdf)

### Makefiles are simple!

Before I leave the house, I need to get dressed.
I use the same simple routine every time:
Underpants, trousers, shirt, pullover, socks, shoes, jacket.
Most likely you also have a routine, even though yours might be different.

Some of these steps depend on each other.  
`Make` is good for handling dependencies.  
Let's try to express my routine as a `Makefile`.

```make
dress: trousers shoes jacket
	@echo "All done. Let's go outside!"

jacket: pullover
	@echo "Putting on jacket."

pullover: shirt
	@echo "Putting on pullover."

shirt:
	@echo "Putting on shirt."

trousers: underpants
	@echo "Putting on trousers."

underpants:
	@echo "Putting on underpants."

shoes: socks
	@echo "Putting on shoes."

socks: pullover
	@echo "Putting on socks."
```

If we execute the `Makefile`, we get the following output:

```
$ make dress
Putting on underpants.
Putting on trousers.
Putting on shirt.
Putting on pullover.
Putting on socks.
Putting on shoes.
Putting on jacket.
All done. Let's go outside!
```

### What just happened?

Noticed how the steps are in the correct order?
By plainly writing down the dependencies between the steps, `make` helps us to execute them correctly.

Each build step has the following structure:

```make
target: [dependencies]
	<shell command to execute>
	<shell command to execute>
	...
```

* The first target in a `Makefile` will be executed by default when we call `make`.  
* The order of the targets does not matter.  
* Shell commands must be indented with a tab.
* Add an `@` sign to suppress output of the command that is executed.
* If `target` isn't a file you want to build, please add `.PHONY <target>` at the end of the build step.
  Common phony targets are: clean, install, run,...

  ```make
  install: 
  	npm install
  .PHONY: install
  ```
  Otherwise, if somebody creates an `install` directory, `make` will silently fail, because the build target already exists.

Congratulations! You've learned 90% of what you need to know about `make`.

### Next steps

Real `Makefiles` can do much more! They will [only build the files that have changed](https://stackoverflow.com/a/3798609/270334) instead of doing a full rebuild.
And they will do [as much as possible in parallel](https://stackoverflow.com/a/3841803/270334).