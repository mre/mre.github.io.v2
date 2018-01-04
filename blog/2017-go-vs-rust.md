extends: default.liquid

title:      Go vs Rust? Choose Go.
date:       15  Sep 2017 00:00:00 +0000
humandate:  15th of September 2017
path:       2017/go-vs-rust
social_img: 2017_gopher.png
comments: 
  - <a href="https://news.ycombinator.com/item?id=15266066">Hacker News</a>
  - <a href="https://www.reddit.com/r/golang/comments/70iwcd/go_vs_rust_choose_go/">Reddit</a>
excerpt: Rust or Go, which one should I choose? is a question I get quite often.
         Both languages seem to be competing for the same user base and they both seem to be
         *systems programming* languages, so there must be a clear winner, right?  
         
         It's not so easy. Both languages have a different scope. Golang shines for writing microservices and for typical "DevOps" tasks, but it is not a systems programming language. Rust is stronger for tasks where concurrency, safety and/or performance are important; but it has a steeper learning curve than Go.
---

<figure>
    <div class="loader">
            <object data="/img/posts/2017/go-vs-rust/hero.svg" type="image/svg+xml"></object>
            <img class="frozen" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA8AAAAICAMAAAARDVXAAAAAnFBMVEX////n5eTj4eH+/v78+PPHwLivrKeblZGfmpfNzM2IkpPV2Nj//PiuopSwqZSml3agjmy6tJirppOCkpba3d335uGWeWuoupmqy7NrXlCszLCuuJOhjnP+6tb04t2ogm25vKfHyauWnJ7Iyqq5tpvzxZT5+vnttXmxytm3ztzH1du0zdy3zNr9+fT+8uW0y9rM0tHNz8vL19u7z9xCrukbAAAAMElEQVR42mNiQAVQPiMTMxKfhRUIOLm4oXweTiiA8jlx8GH6OaDgMZR/ix0MLoPkAXYYBDS1ha+TAAAAAElFTkSuQmCC" />
  </div>
  <figcaption>
Gopher designed with <a href="https://gopherize.me">Gopherize.me</a>. Cogwheels designed by <a href='http://www.freepik.com/free-vector/gear-background-with-pieces-in-different-colors_966124.htm'>Freepik</a>.
  </figcaption>
</figure>

"Rust or Go, which one should I choose?" is a question I get quite often.
Both languages seem to be competing for the same user base and they both seem to be
*systems programming* languages, so there must be a clear winner, right?

**tl;dr**: *It's not so easy. Both languages have a different scope. Golang shines for writing microservices and for typical "DevOps" tasks, but it is not a systems programming language. Rust is stronger for tasks where concurrency, safety and/or performance are important; but it has a steeper learning curve than Go.*

### Go: practical, pragmatic, blunt

I don't think Go is an elegant language. Its biggest feature is simplicity.
Go is not even a systems programming language. While it's great for writing microservices and tooling around backend infrastructure, I would not want to write a kernel or a memory allocator with it.

But with Go, you *get things done* &mdash; fast.  
Go is one of the most productive languages I've ever worked with.
The mantra is: solve real problems today. 

### Rust's strong guarantees come with a cost

Rust in comparison is **hard**. It took me many months to become somewhat productive.
You need to invest a serious amount of time to see any benefit.
Rust is already a powerful language and it gets stronger every day.
It feels much more like a *pragmatic Haskell* to me than a *safer C*.

Don't get me wrong: I personally love Rust and it helped me become a better programmer. It is certainly a nice language to learn. The big question is, if it is the right choice for your next major project.

Here's the thing: if you choose Rust, usually you need the guarantees, that the language provides:

* Safety against `Null` pointers, race conditions and all sorts of low-level threats.
* Predictable runtime behavior (zero cost abstractions and no garbage collector).
* (Almost) total control over the hardware (memory layout, processor features).
* Seamless interoperability with other languages.

If you don't **require** any of these features, Rust might be a poor choice for your next project.
That's because these guarantees come with a cost: ramp-up time.
You'll need to unlearn bad habits and learn new concepts.
Chances are, you will [fight with the borrow checker](https://m-decoster.github.io/2017/01/16/fighting-borrowchk/) a lot when you start out.

### Some things I prefer in Go

* Fast compile times
* Pragmatic problem-solving approach
* Nice ecosystem for typical *DevOps* tasks
* Batteries-included standard-library
* IDE support
* Simple error handling
* The mascot 😉

### Some things I prefer in Rust

* Safety: No null pointers, no data races,...
* Fine-grained system control
* Incredible runtime speed (comparable with C/C++)
* Zero-cost abstractions
* Awesome, open-minded community
* Simple package management with cargo
* Support for Generics in form of traits
* C interop and FFI

### Conclusion

99% of the time, Go is "good enough" and that 1% where it isn't, you'll know.
And then take a look at Rust, because the two languages complement each other pretty well.

After all is said and done, [Rust and Go are not really competitors](https://dave.cheney.net/2015/07/02/why-go-and-rust-are-not-competitors).