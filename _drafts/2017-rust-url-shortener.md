extends: default.liquid

title:      Launching a URL Shortener in Rust using Rocket
date:       18 Mar 2017 00:00:00 +0000
humandate:  18th of March 2017
path:       2017/rust-url-shortener
---

<img src="/img/posts/2017/rocket.svg" alt="A rocket travelling through space"/>

One common Systems Design task in interviews is to sketch the software architecture of a URL shortener (a [bit.ly](https://bit.ly) clone, so to say).
Since I was playing around with Rocket, why not give it a try?

### Requirements 

A URL shortener has two main responsibilities:

* Create a shorter URL from a longer one (d'oh)
* Redirect to the longer link when the short link is requested.

Let's call our service `rust.ly` (*Hint, hint:* the domain is still available at the time of writing...).

First we create a new Rust project:

```rust
cargo new --bin rustly
```

Next, we add Rocket to our `Cargo.toml`:

```rust
[dependencies]
rocket = "0.2.2"
rocket_codegen = "0.2.2"
```

Since Rocket requires cutting edge Rust features, we need to use a nightly
build.

```Rust
rustup override set nightly
```

Warning: Most likely you need to get the very newest Rocket and Rust nightly versions.
Otherwise you might get some entertaining error messages.

### A first prototype

Now we can start coding our little service.
Let's first write a simple "hello world" skeleton to get started.
Put this into `src/main.rs`:

```rust
#![feature(plugin)]
#![plugin(rocket_codegen)]

extern crate rocket;

#[get("/<id>")]
fn lookup(id: &str) -> String {
    format!("⏩ You requested {}. Wonderful!", id)
}

#[get("/<url>")]
fn shorten(url: &str) -> String {
    format!("💾 You shortened {}. Magnificient!", url)
}

fn main() {
    rocket::ignite().mount("/", routes![lookup])
                    .mount("/shorten", routes![shorten])
                    .launch();
}
```

### Whoa Matthias! What is this sourcery?

Under the hood, Rocket is doing some magic to enable this nice syntax.
More specifically, we use the `rocket_codegen` crate for that.
(It's implemented as a compiler plugin, which is also the reason why we need to use nightly Rust)

In order to bring the rocket library into scope, we write `extern crate rocket;`.

We defined the two *routes* for our service. Both routes will respond to a `GET` request.  
This is done by adding an *attribute* named `get` to a function.
The attribute can take additional arguments.
In our case, we define an `id`` variable for the `lookup` endpoint and a `url` variable for the `shorten` endpoint. 
Both variables are unicode string slices. Since Rust has awesome unicode support, we allow different character sets like arabic or emoji out of the box.
Just to show off, we can return a nice status string with an emoji. 🕶

Lastly we need a main function which launches rocket and mounts our two routes. This way, they become publicly available.
If you want to know even more about the in-depth details, I may refer you to the [official documentation](https://rocket.rs/guide).

Let's check if we're on the right track by running the application.

```rust
cargo run
```

After some compiling, you should get some lovely startup output from Rocket:

```rust
🔧  Configured for development.
    => address: localhost
    => port: 8000
    => log: normal
    => workers: 8
🛰  Mounting '/':
    => GET /<hash>
🛰  Mounting '/shorten':
    => GET /shorten/<url>
🚀  Rocket has launched from http://localhost:8000...
```

Sweet! Let's call our service.

```
> curl localhost:8000/shorten/www.matthias-endler.de
💾 You shortened www.matthias-endler.de. Magnificient!

> curl localhost:8000/www.matthias-endler.de
⏩ You requested www.matthias-endler.de. Wonderful!
```

So far so good. Let's focus on the actual URL shortening now.

### Data storage and lookup

Our data storage needs to be able to quickly retrieve a shortend URL.  
A good datastructure, which offers O(1) lookup time is a hashmap.
In Python this is known as a dictionary, in PHP it's an associative array
and in lolcode that would be a `BUKKIT`.
Anyway, the concept is the same.

<img src="/img/posts/2017/hash.svg" alt="A hashmap datastructure"/>

We need to keep the stored data over many requests. That means we need to keep the state of our service somewhere.
In a production scenario we could use some NoSQL data store like a Redis cluster for that. This allows us to easily scale the service and to have some failover.
Since the goal is to play with Rocket and learn some Rust, we will simply use an
in-memory store. As soon as we restart the server, the data is gone.

Rocket has a feature called [managed state](https://rocket.rs/guide/state/).

In our case, we want to manage a *repository* of URLs.

First, let's create another file named `src/repository.rs` and implement our
Repository:

```rust
use std::collections::HashMap;
use shortener::Shortener;

pub struct Repository {
    urls: HashMap<String, String>,
    shortener: Shortener,
}

impl Repository {
    pub fn new() -> Repository {
        Repository {
            urls: HashMap::new(),
            shortener: Shortener::new(),
        }
    }

    pub fn store(&mut self, url: &str) -> String {
        let id = self.shortener.next_id();
        self.urls.insert(id.to_owned(), url.to_string());
        id
    }

    pub fn lookup(&self, id: &str) -> Option<&String> {
        self.urls.get(id)
    }
}
```

As you can see, we don't actually shorten anything. We merely create a short, unique ID. That's because most hashing algorithms produce fairly long URLs.

Witihin this module we first import the `HashMap` implementation from the standard library.
We we also include `shortener::Shortener;`, which will help us to shorten the URLs in the next step. Don't worry too much about that just yet.
By convention we implement a `new()` function to create a new Repository struct with an empty `HashMap` and a new `Shortener`. Additionally we have two methods, `store` and `lookup`. 

`store` takes a URL and writes it to our in-memory HashMap storage. It uses our yet to be defined shortener to create a unique id. It returns the shortened ID for the entry.
`lookup` gets a given ID from the storage and returns it as an Option. If the ID is found, the return value will be `Some(url)`, if there is no match it will return `None`. 

### Side notes (can safely be skipped)

A seasoned (Rust) Programmer might do a few things differently here. Did you notice the tight coupling between the repository and the shortener? In a production system, `Repository` and `Shortener` might simply be concrete implementations of traits (which are a bit like interfaces in other languages, but more powerful). For example, we could have a `Cache` trait, which defines a `store` and a `lookup` method. `Repository` would implement `Cache`. This way we get a clear interface and we can easily switch to a different implementation (e.g. a `RedisCache`). Also we could have a `MockRepository` to simplify testing. Same for `Shortener`.

Also, might also use the `Into` trait to support both, `&str` and `String` as a parameter of `store`:

```rust
pub fn store<T: Into<String>>(&mut self, url: T) -> String {
		let id = self.shortener.shorten(url);
		self.urls.insert(id.to_owned(), url.into());
		id
}
```

If you're curious about this, read [this article from Herman J. Radtke III](http://hermanradtke.com/2015/05/06/creating-a-rust-function-that-accepts-string-or-str.html).
For now, let's keep it simple.

### Actually shortening URLs

As a final step, we need to implement the URL shortener itself.
You might be surpised how much was written about URL shortening [all over the web](https://blog.codinghorror.com/url-shortening-hashes-in-practice/).
One common way is to create [short urls using base 62 conversion](http://stackoverflow.com/questions/742013/how-to-code-a-url-shortener).

After looking around some more, I found this sweet crate called [harsh](https://github.com/archer884/harsh), which perfectly fits the bill.  


To use `hashids`, we add it as a dependency to our `Cargo.toml`:

```
[dependencies]
hashids = "1.0.0"
```

Then we add the crate at the top of to our `main.rs`:

```
extern crate hashids;
```











### Closing thoughts

I have to admit that I struggled a bit to get mutable state working in Rocket.

```rust
#[get("/<url>")]
fn store(repo: State<Repository>, url: &str) {
    repo.store(url);
}

fn main() {
    rocket::ignite().manage(Repository::new())
                    .mount("/store", routes![store])
                    .launch();
}
```

The compiler did not like that:

```rust
error: cannot borrow immutable borrowed content as mutable
  --> src/main.rs
   |
   |     repo.store(url);
   |     ^^^^ cannot borrow as mutable
```




