title: A Pragmatic Haskell


Clojure, Lisp,..
Among all the popular functional languages, Haskell is arguably one of the most powerful ones.


traditionally known for being good at, e.g. building DSLs, type systems, interpreters, etc.

 The state of the Haskell ecosystem is that it is amazing at encouraging people to write libraries, especially libraries to assist in writing haskell code but amazingly bad at encouraging people to write actual programs, especially actual programs useful for something that isn't writing code.

 Projects
 pandoc, xmonad

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
