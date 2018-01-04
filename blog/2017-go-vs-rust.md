extends: default.liquid

title:      Go vs Rust? Choose Go.
subtitle: ""
date:       15  Sep 2017 00:00:00 +0000
humandate:  15th of September 2017
path:       2017/go-vs-rust
social_img: 2017_gopher.png
excerpt:    "Rust or Go, which one should I choose? This is a question I get quite often. My answer is simple: use Go."
comments: 
  - <a href="https://news.ycombinator.com/item?id=15266066">Hacker News</a>
  - <a href="https://www.reddit.com/r/golang/comments/70iwcd/go_vs_rust_choose_go/">Reddit</a>
translations: null
css: null
---

<figure>
            <div class="loader">
            <object data="/img/posts/2017/go-vs-rust/hero.svg" type="image/svg+xml"></object>
            <img class="frozen" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA8AAAAKCAMAAABcxfTLAAABOFBMVEX////49/bLycW4tbG1sq7PzMj6+vrX2trMz9D7+/v+/v316du+ta6xsKualZGemJWUjYmcl5LU1tWXn6C/w8S+wsLq28jMxbqZn6KZinNlWVS9pWuRkI6zsKKWm6Gmra2UqK+5vr7//fu6loBjZWLLvIPGzKOummyCdF+ummvFzJ3NvXt6cmaWoaLz8/H14NqzjoV0Z1G10q90xtnLyJCAcV3SyYlpx9mtyrV/aEfCspz927nqu6y9g3N1WkrRv2u7x5Ooll9NQT2pll69x5fUu2COc1nrwI/81Kr9+fe6mnyvl3mvydnE0c6uydm1xtCtyNmwydjiwZ7+7+DWsonSsIqoxdfC1N7I1dq80d3Xz8TXtpTE1t7KzcfKzsiwytrf3Nvd3t63z97T293T1tPT19PJ2OLk4+IAgmFfAAAATklEQVR42o3HsRXDIAwE0INEAomjyQjZn9rezpaeG0r/7leEUj9fUbRuiPt4/EjmuYn/5yY+X97IMuKHu1uSfq44LoWqiEGB/FK2xBa/ARK/CJfrlinZAAAAAElFTkSuQmCC" />
        </div>
  <figcaption>
Gopher designed with <a href="https://gopherize.me">Gopherize.me</a>. Cogwheels designed by <a href='http://www.freepik.com/free-vector/gear-background-with-pieces-in-different-colors_966124.htm'>Freepik</a>.
  </figcaption>
</figure>


"Rust or Go, which one should I choose?" is a question I get quite often.
My answer is simple: use Go.

Not because Go is the better language,
but because people want a simple answer to a (seemingly) simple question.

Both languages seem to be competing for the same user base and they both seem to be
"systems programming" languages, so there must be a winner, right?

Here's the thing: if you choose Rust, usually you need the guarantees, that the language provides:

* Safety against `Null` pointers, race conditions and all sorts of low-level threats.
* Predictable runtime behavior (zero cost abstractions and no garbage collector).
* (Almost) total control over the hardware (memory layout, processor features).
* Seamless interoperability with other languages.

If you don't **require** any of these features, Rust might be a poor choice for your next project.
That's because these guarantees come with a cost: ramp-up time.
You'll need to unlearn bad habits and learn new concepts.
Chances are, you will [fight with the borrow checker](https://m-decoster.github.io/2017/01/16/fighting-borrowchk/) a lot when you start out.

With Go, you get things done fast.  
Go is one of the most productive languages I've ever worked with.
The mantra is: solve real problems today. 

I don't think Go is an elegant language. Its biggest feature is simplicity.
Go is not even a systems programming language. While it's great for writing microservices and tooling around backend infrastructure, I would not want to write a kernel or a memory allocator with it.

Rust in comparison is **hard**. It took me many months to become somewhat productive.
You need to invest a serious amount of time to see any benefit.
Rust is already a powerful language and it gets stronger every day.
It feels much more like a "pragmatic Haskell" to me than a "safer C".

99% of the time, Go is "good enough" and that 1% where it isn't, you'll know.
And then take a look at Rust, because the two languages complement each other pretty well.
