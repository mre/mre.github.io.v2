extends: default.liquid

title:      What Makes Rust Fast
date:       10 Oct 2017 00:00:00 +0000
humandate:  10th of October 2017
path:       2017/what-makes-rust-fast
---

tl;dr: Rust is a safe systems-programming language. But besides its guaranteed safety, it also rivals C/C++ in speed for some datasets.
Let me show you the tricks that Rust make Rust fast, which are possible but very hard to pull off in other languages.
I will talk about agressive compile-time optimizations, zero-cost abstractions, fearless concurrency, and more.
Concrete examples come from tools like ripgrep, serde, tokio and diesel.