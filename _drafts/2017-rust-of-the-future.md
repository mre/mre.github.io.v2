draft: true
---

The future of Rust

Let me point out the obvious first: yes, the title is a little clickbaity. Also,
you might be asking why *I* should be entitled to talk about the future of Rust. After
all I'm neither part of the Rust core team, nor a big contributor to the Rust
ecosystem. To that I answer: why not? It's fun to think about the future of
Systems Programming in general and Rust in particular. To make it big, we need
two things: [roots and wings](http://www.goodreads.com/quotes/726646-there-are-two-things-children-should-get-from-their-parents).

If I think about the future of Rust, of course there are some near-term goals
that the core team commited to. Faster compile times and a more gentle learning
curve come to mind.

But in this post I want to explore some more exotic ways where Rust could shine in
five or ten years from now.

### Taking safety for granted

With languages like Rust and [Crystal](https://crystal-lang.org/), a whole class of errors are a thing of the past. No null pointers, no segfaults, no memory leaks, no data races.
Programmers of the future will take this for granted; just like we expect
proper version control, IDEs, and debugging tools today.

### An explosion of new ideas

Rust will see an explosion of staggering libraries.
This will affect all areas of programming. Concurrent HashMaps and Queues, high-level parallel programming abstractions and language extensions via compiler plugins.

The Rust of the future is safer, faster and more expressive.
It will have less boilerplate code and an even clearer mission statement.
It could be a more pragmatic Haskell.

### Machine learning

Machine Learning is one other area where we might see a lot of traction in the
future. The most popular langauges for ML are R, Python and C++ (in that order)

[DIAGRAM POPULARITY]

We've observed that while prototypes are mostly written in dynamically typed
languages like Python and R, once an algorithm reaches production level quality
it is often rewritten in faster languages such as C++.
It is not unthinkable that Rust is going to be some healthy competition for C++ in the near future.
The benchmarks of [leaf](https://github.com/autumnai/leaf) are already nothing short of
impressive.

Gaming is another area where Rust might shine. On one side because of the
tooling, which is simply awesome to cross compile code.
Also Vulcan support might be the best of class.
The killer feature is of course the combination of safety and performance. If
you ship a game to a million players and they threw money at you, you want to be sure that it doesn't crash.
The graphics libraries are not ready for a AAA title yet, but there is some
promising work.

### Bridging the gap between Backend and Frontend

Rust has a compiler-backend for emscripten. This means it can be built to run on
the browser transpiled to Javascript.
Running server-side code on the client is nothing new since the dawn of node.js.
The cool thing is, that Rust has a much richer typesystem and much more powerful
abstractions such as Algebraic Datatypes and monadic Error handling, that make
it a serious competitor for Javascript in that area.

### Combining with other languages

A common pattern is to optimize some core part in Rust that has hard safety/performance
requirements, while leaving the rest of the application untouched.
Rust has been proven to work very nicely with other languages. 
Partly because of the C-compatiblity and partly because there is no Garbage
Collector.
I think this trend will only become stronger in the long run.
There are projects like Corrode to automatically translate C code to Rust in
order to port legacy tooling automatically to Rust. [ TALK AIR MOZILLA SAN FRANCISCO
MEETUP JANUARY CORRODE]

### Space travel?

Maybe we will also see static verification of the Rust core. A language that is
formally proven to be correct opens new doors in conservative industries. I
could think of the Space industry. Wouldn't it be nice to safely land a Spacecraft on
Mars that is controlled by Rust?

Overall I see huge potential in these different areas.
I have no idea where Rust is gonna lead us, but I'm sure that it's going to be
awesome.
