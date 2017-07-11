The tunnels below New York are 600 inch in diamater.
That's because the ..
That's because the ..
That's because the ..
That's because the ..

Why am I telling you this?

We have the same problem in our software infrastructure.

The C compiler uses batch mode to compile your source files.
That's because the ..
That's because the ..
That's because the ..
That's because the ..


Over the years we've accumulated tons and tons of technical debt.

All of this comes with severe [technical vulnerabilities](https://unhandledexpression.com/2017/07/10/why-you-should-actually-rewrite-it-in-rust/).

To fix that we should slowly start replacing legacy code with well-tested, safe
alternatives.
I'm not talking about the Big Rewrite [tm], I'm talking about making the most
critical parts more stable from within.

Rust is a perfect fit for that: it's safe and doesn't have a runtime or a
garbage collector. Therefore it happily integrates with your old stuff.
You can easily call Rust from C and C from Rust.

For a rough, initial port of your old code to Rust, you could use tools like
corrode.
Watch THIS talk to find out more on how to do it.



