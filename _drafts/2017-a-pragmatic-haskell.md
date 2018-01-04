extends: default.liquid

title:      A Productive Haskell
subtitle: ""
date:       26  Aug 2017 00:00:00 +0000
humandate:  26th of August 2017
path:       2017/productive-haskell
social_img: null
comments: null
translations: null
css: null
---

Back in University I worked on a project, which bridged the gap between Java and Haskell.
It was a tool for teaching students the basics of computational geometry.
That might sound frightening in the beginning, but it really was not.

My task was to send a bunch of 2D-Points from Java to Haskell, run a function and return the result to Java.
For example, my Haskell code calculated the [convex hull](https://en.wikipedia.org/wiki/Convex_hull) on the input data.

<img src="/img/posts/2017/haskell-java/convex-hull.svg" alt="Calculating the convex hull on a point cloud"/>

<figure>
  <img src="/img/posts/2017/haskell-java/convex-hull.jpg" alt="A GUI tool for computational geometry">
  <figcaption>
  User Interface of the tool, which used my Haskell code to run geometrical computations.
  Advisor: <a href="http://www.ai6.uni-bayreuth.de/en/members/fabian-stehn-en.html">Dr. Fabian Stehn</a>, Universit&auml;t Bayreuth
  </figcaption>
</figure>



Don't get me wrong: I really want to *like* Haskell.
After finishing University I now have limited time to learn new things.

Clojure, Lisp,..
Among all the popular functional languages, Haskell is arguably one of the most powerful ones.

Rust programmers are roughly divided into three groups right now:

* You come from a systems programming language like C or C++ and you want more security and high-level abstractions.
* You come from a dynamically typed language (Ruby, PHP, Python) and you want more low-level control and better performance.
* You come from a functional language (Clojure, Haskell, Scala) and you want more low-level control and better performance.





traditionally known for being good at, e.g. building DSLs, type systems, interpreters, etc.

 The state of the Haskell ecosystem is that it is amazing at encouraging people to write libraries, especially libraries to assist in writing haskell code but amazingly bad at encouraging people to write actual programs, especially actual programs useful for something that isn't writing code.

One of the most beautiful programs I've ever seen is pandoc by John MacFarlane.

Pros:

type system
no side-effects
library driven development


Cons: 
do notation for I/O
monadic expressions
ecosystem (package manager, versioning?)
community (especially entering the community)
Garbage collector is tricky for embedded systems


More about Haskell in production:
http://www.stephendiehl.com/posts/production.html

Industrial programmers write code to support themselves.
In my opinion, Rust is a language that could fit the bill here.
Ideologically, it's much closer to Haskell than to C++.

Rust, like JavaScript, is a functional language camouflaged as an object orient one.

Rust:

pros
 productive
 llvm support
 down to the bare metal
 predicatable performance
 no magic
 zero cost abstractions
 No garbage collector 
 development ecosystem -> By now this has become a strength in my opinion. It is on par with Haskell.
 RLS, Visual Studio Code, Debugger,...
 RFC process! All language changes are discussed in the open (including "how do we teach this")


cons (like haskell)
    compile time!
    huge language with multiple ways to solve a problem
    tendency to be too generic
    new ecosystem
    no books yet
    high barrier of entry: takes years to master
    module system -> there's a PR for that


Rust is not as "pure" as Haskell. 
Instead of an [I/O Monad](https://wiki.haskell.org/IO_inside), it has an OOP-based I/O approach with [`std::io`](https://doc.rust-lang.org/std/io/)
http://book.realworldhaskell.org/read/io.html

It follows a pragmatic approach.


Rust is a big language and it gets bigger every day.
It takes a long time to master. Depending on your background, it might be years.
Compare that to Go, where you can be productive after a few days.
