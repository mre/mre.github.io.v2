extends: default.liquid

title:      The Rust of the Future
date:       10 Apr 2017 00:00:00 +0000
humandate:  10th of April 2017
path:       2017/rust-of-the-future
---

<img src="/img/posts/2017/booster.jpg" alt="The booster of a NASA rocket">

Let me point out the obvious first: yes, the title is a little clickbait-y. Also,
you might be asking why should *I* of all people be entitled to talk about the future of Rust. After
all I'm neither part of the Rust core team, nor a big contributor to the Rust
ecosystem. To that I answer: why not? It's fun to think about the future of
Systems Programming in general and Rust in particular. To make it big, we need
two things: [roots and wings](http://www.goodreads.com/quotes/726646-there-are-two-things-children-should-get-from-their-parents).

Of course there are some near-term goals that the core team commited to. Faster compile times and a more gentle learning curve come to mind.

But in this post I want to explore some more exotic ways where Rust could shine in
five or ten years from now.

### Machine learning

Right now, the most popular languages for Machine Learning are R, Python and C++ (in that order).

[DIAGRAM POPULARITY]

We've observed that while prototypes are mostly written in dynamically typed
languages like Python and R, once an algorithm reaches production level quality
it is often rewritten in faster languages such as C++.
It is not unthinkable that Rust is going to be some healthy competition for C++ in the near future.
The benchmarks of [leaf](https://github.com/autumnai/leaf) are already nothing short of
impressive.

### Blockbuster games

Gaming is another area where Rust might shine. 
It's financially attractive for Game Studios to support multiple platforms withouth much
effort. Cargo and rustup make cross compiling easy.
Modern libraries slowly fill the tooling gaps for large-scale game development.
Rust's support for the Vulcan 3D graphics API might already be the best of class.
The killer feature though, is the unique combination of safety and performance.
If you ship a game to a million players and they threw money at you, you'll better be sure that it doesn't crash.

### Bridging the gap between Backend and Frontend

Rust has a compiler-backend for emscripten. This means it can be built to run on
the browser transpiled to Javascript.
Running server-side code on the client is nothing new since the dawn of node.js.
The cool thing is, that Rust has a much richer typesystem and much more powerful
abstractions such as Algebraic Datatypes and monadic Error handling, that make
it a good supplemental language for Javascript in that area.

### Space travel

Maybe eventually we will also see formal verification of the Rust core. Projects like [RustBelt](http://plv.mpi-sws.org/rustbelt/) could open new doors in conservative industries like the Space industry. Wouldn't it be nice to safely land a Spacecraft on Mars that is controlled by Rust (or one of its spiritual successors)?
I wonder if SpaceX is experimenting with Rust already...

### Integrating with other languages

There are some other areas I haven't even mentioned yet: finance, the
medical industry or scientific research, just to name a few.
In all cases, Rust might be a good fit. Right now the biggest barrier to entry 
is probably the huge amount of legacy code. Many industries maintain large codebases in Cobol,
Ada, C or Fortran that are not easily rewritten.

Fortunately Rust has been proven to work very nicely with other languages. 
Partly because of the C-compatiblity and partly because there is no Runtime or Garbage Collector.
A common pattern is to optimize some core part of an application in Rust that has hard safety/performance
requirements, while leaving the rest untouched.
I think this symbiosis will only become stronger in the long run.
There are promising projects like [Corrode](https://fosdem.org/2017/schedule/event/mozilla_translation_from_c_to_rust/) which attempt to automatically translate C code to Rust.

### Summary

Overall I see huge potential for Rust in areas where safety, performance or total control over the machine are essential. With languages like Rust and [Crystal](https://crystal-lang.org/), a whole class of errors are a thing of the past. No null pointers, no segfaults, no memory leaks, no data races.
I find it encouraging that future generations of programmers will take all of this for granted.

