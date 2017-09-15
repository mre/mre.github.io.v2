extends: default.liquid

title:      Go vs Rust? Choose Go.
date:       15  Sep 2017 00:00:00 +0000
humandate:  15th of September 2017
path:       2017/go-vs-rust
---

<figure>
            <object data="/img/posts/2017/go-vs-rust/hero.svg" type="image/svg+xml"></object>

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