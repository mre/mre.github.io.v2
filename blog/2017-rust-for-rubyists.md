extends: default.liquid

title:      Rust for Rubyists
subtitle:   Idiomatic Patterns in Rust and Ruby
date:       17 Dec 2017 00:00:00 +0000
humandate:  17th of Dezember 2017
path:       2017/rust-for-rubyists
css:        assets/posts/rust-for-rubyists.css
---

Recently I came across a delightful article on idiomatic Ruby.
I'm not a good Ruby developer by any means, but I realized, that a lot of the patterns are also quite common in Rust.
What follows is a side-by-side comparison of idiomatic code in both languages.

The Ruby code samples are from the [original article](https://medium.com/the-renaissance-developer/idiomatic-ruby-1b5fa1445098).

### Map

The first example is a pretty common iteration over elements of a container using `map`.

<a class="example" href="https://gist.github.com/LeandroTk/64ca7d6f5279e08589e21d799544e878#file-map-rb">
<div class="ruby icon"></div>

```ruby
user_ids = users.map { |user| user.id }
```
</a>

The `map` concept is also pretty common in Rust.
Compared to Ruby, we need to be a little more explicit here:
If `users` is a vector of `User` objects, we first need to create an iterator from it:

<a class="example" href="https://play.rust-lang.org/?gist=5a61b7b44ff01fabbc07dba9409d9b97&version=stable">
<div class="rust icon"></div>

```rust
let user_ids = users.iter().map(|user| user.id);
```
</a>

You might say that's quite verbose, but this additional abstraction allows us to express an important concept:
will the iterator take ownership of the vector, or will it not?

* With `iter()`, you get a "read-only view" into the vector. After the iteration, it will be unchanged.
* With `into_iter()`, you take ownership over the vector. After the iteration, the vector will be gone.
  In Rust terminology, it will have *moved*.
* Read some more about the [difference between `iter()` and `into_iter()` here](http://hermanradtke.com/2015/06/22/effectively-using-iterators-in-rust.html).


The above Ruby code can be simplified like this:

<a class="example" href="https://gist.github.com/LeandroTk/258652cbaea308ccfeddc5df5bb9f37b#file-each_vs_map_3-rb">
<div class="ruby icon"></div>

```ruby
user_ids = users.map(&:id)
```

</a>

Something similar can be done in Rust:

<a class="example" href="https://play.rust-lang.org/?gist=131027a481d4691821315ad308d26dc9&version=stable">
<div class="rust icon"></div>

```rust
let user_ids = users.iter().map(id);
```
</a>

I'm cheating a little bit here because I omit a critical piece &mdash; creating a closure to extract the field from each item.
It looks like this:

<a class="example" href="https://play.rust-lang.org/?gist=131027a481d4691821315ad308d26dc9&version=stable">
<div class="rust icon"></div>

```rust
let id = |u: &User| u.id;
```

</a>

That's some more legwork course, but it's a nice trick and if you access the `id` more than once, it might pay off to define that closure.

Probably the most idiomatic way to do that in Rust, though, is to use so-called [Universal Function Call Syntax](https://doc.rust-lang.org/book/first-edition/ufcs.html).<sup><a href="#fn1" id="ref1">1</a></sup>

<a class="example" href="https://play.rust-lang.org/?gist=51069ee76e5d534621ccd6633474b630&version=stable">
<div class="rust icon"></div>

```rust
let user_ids = users.iter().map(User::id);
```

</a>

Also note, that `map()` returns another iterator and not a collection.
If you want a collection, you would have to run [`collect()`](https://doc.rust-lang.org/std/iter/trait.Iterator.html#examples-23) on that, as we'll see later.

### Each

Speaking of iteration, one pattern that I see a lot in Ruby code is this:

<a class="example" href="https://gist.github.com/mre/f6552360a4c08f2c064da7f00d434d5c">
<div class="ruby icon"></div>

```ruby
["Ruby", "Rust", "Python", "Cobol"].each do |lang|
  puts "Hello #{lang}!"
end
```

</a>

Since [Rust 1.21](https://blog.rust-lang.org/2017/10/12/Rust-1.21.html), this is now also possible:

<a class="example" href="https://play.rust-lang.org/?gist=549d38bc43549fd5444c731d2bc3a47b&version=stable">
<div class="rust icon"></div>

```rust
["Ruby", "Rust", "Python", "Cobol"]
    .iter()
    .for_each(|lang| println!("Hello {lang}!", lang = lang));
```

</a>



Although, more commonly one would write that as a normal for-loop in Rust:

<a class="example" href="https://play.rust-lang.org/?gist=a7691b56b1dfd1fb19aa00a91b39589d&version=stable">
<div class="rust icon"></div>

```rust
for lang in ["Ruby", "Rust", "Python", "Cobol"].iter() {
    println!("Hello {lang}!", lang = lang);
}
```

</a>

### Select and filter

Let's say you want to extract only even numbers from a collection in Ruby.

<a class="example" href="https://gist.github.com/LeandroTk/f341051889e27c99ddd66c075e5ef6d0#file-map_vs_select_1-rb">
<div class="ruby icon"></div>

```ruby
even_numbers = [1, 2, 3, 4, 5].map { |element| element if element.even? } # [ni, 2, nil, 4, nil]
even_numbers = even_numbers.compact # [2, 4]
```
</a>

In this example, before calling `compact`, our `even_numbers` array had `nil` entries.
Well, in Rust there is no concept of `nil` or `Null`. You don't need a `compact`.
Also, `map` doesn't take predicates. You would use `filter` for that:

<a class="example" href="https://play.rust-lang.org/?gist=494d6e3ff016c21931e3495b10c8f6ee&version=stable">
<div class="rust icon"></div>

```rust
let even_numbers = vec![1, 2, 3, 4, 5]
    .iter()
    .filter(|&element| element % 2 == 0);
```
</a>

or, to make a vector out of the result

<a class="example" href="https://play.rust-lang.org/?gist=45c6dbd2d35316c73165c5571d66df9d&version=stable">
<div class="rust icon"></div>

```rust
// Result: [2, 4]
let even_numbers: Vec<i64> = vec![1, 2, 3, 4, 5]
    .into_iter()
    .filter(|element| element % 2 == 0).collect();
```
</a>

Some hints:

* I'm using the type hint `Vec<i64>` here because, without it, Rust does not know what collection I want to build when calling `collect`.
* `vec!` is a macro, which creates a preallocated vector at compile time.
* Instead of `iter`, I use `into_iter`. This way, I take ownership of the elements in the vector. With `iter()` I would get a `Vec<&i64>` instead.

In Rust, there is no `even` method on numbers, but that doesn't keep us from defining one!

<a class="example" href="https://play.rust-lang.org/?gist=c289c2a1cf8bd870cbd5cc2cd60ea791&version=stable">
<div class="rust icon"></div>

```rust
let even = |x: &i64| x % 2 == 0;
let even_numbers = vec![1, 2, 3, 4, 5].into_iter().filter(even);
```
</a>

In a real-world scenario, you would probably use a third-party package (crate) like [`num`](https://github.com/rust-num/num) for numerical mathematics:

<a class="example" href="https://play.rust-lang.org/?gist=e4bbbf60b7b1cbbedfb363672731bf53&version=stable">
<div class="rust icon"></div>

```rust
extern crate num;
use num::Integer;

fn main() {
    let even_numbers: Vec<i64> = vec![1, 2, 3, 4, 5]
        .into_iter()
        .filter(|x| x.is_even()).collect();
}
```
</a>

In general, it's quite common to use crates in Rust for functionality that is not in the standard lib.
Part of the reason why this is so well accepted is, that [cargo](https://github.com/rust-lang/cargo) is such a rad package manager.
(Maybe because it was built by no other than [Yehuda Katz](http://yehudakatz.com/about/) of Ruby fame. 😉)

As mentioned before, Rust does not have `nil`. However, there is still the concept of operations that can fail.
The canonical type to express that is called [`Result`](https://doc.rust-lang.org/std/result/).

Let's say you want to convert a vector of strings to integers.

<a class="example" href="https://play.rust-lang.org/?gist=1365d177503ee2d32c4aa594263ee4d4&version=stable">
<div class="rust icon"></div>

```rust
let maybe_numbers = vec!["1", "2", "nah", "nope", "3"];
let numbers: Vec<_> = maybe_numbers
    .into_iter()
    .map(|i| i.parse::<u64>())
    .collect();
```
</a>

That looks nice, but maybe the output is a little unexpected. `numbers` will also contain the parsing errors:

<a class="example" href="https://play.rust-lang.org/?gist=1365d177503ee2d32c4aa594263ee4d4&version=stable">
<div class="rust icon"></div>

```rust
[Ok(1), Ok(2), Err(ParseIntError { kind: InvalidDigit }), Err(ParseIntError { kind: InvalidDigit }), Ok(3)]
```
</a>

Sometimes you're just interested in the successful operations.
An easy way to filter out the errors is by using [`filter_map`](https://doc.rust-lang.org/std/iter/trait.Iterator.html#method.filter_map):

<a class="example" href="https://play.rust-lang.org/?gist=afdc823ec2e165ac0a03948fb323d305&version=stable">
<div class="rust icon"></div>

```rust
let maybe_numbers = vec!["1", "2", "nah", "nope", "3"];
let numbers: Vec<_> = maybe_numbers
    .into_iter()
    .filter_map(|i| i.parse::<u64>().ok())
    .collect();
```
</a>

I changed two things here:

* Instead of `map`, I'm now using `filter_map`.
* Since `filter_map` expects a predicate to filter on, I convert the `Result` return value of `parse` into a boolean by calling `ok()` on it.

The return value contains all successfully converted strings:

<a class="example" href="https://play.rust-lang.org/?gist=afdc823ec2e165ac0a03948fb323d305&version=stable">
<div class="rust icon"></div>

```rust
[1, 2, 3]
```
</a>

The `filter_map` is similar to the `select` method in Ruby:

<a class="example" href="https://gist.github.com/LeandroTk/1ae24e0fece0207f814932b0ac6c4a5e#file-map_vs_select_2-rb">
<div class="ruby icon"></div>

```ruby
[1, 2, 3, 4, 5].select { |element| element.even? }
```
</a>


### Random numbers


Here's how to get a random number from an array in Ruby:

<a class="example" href="https://play.rust-lang.org/?gist=a66785b44094bacb78fa8dd822bfeab5&version=stable">
<div class="ruby icon"></div>

```ruby
[1, 2, 3].sample
```
</a>

That's quite nice and idiomatic!
Compare that to Rust:

<a class="example" href="https://play.rust-lang.org/?gist=bed7fca31737bcbf4b9aed427cc22713&version=stable">
<div class="rust icon"></div>

```rust
let mut rng = thread_rng();
rng.choose(&[1, 2, 3, 4, 5])
```
</a>

For the code to work, you need the `rand` crate. Click on the snippet for a running example.

There are some differences to Ruby. Namely, we need to be more explicit about what random number generator
we want *exactly*. We decide for a [lazily-initialized thread-local random number generator, seeded by the system](https://doc.rust-lang.org/rand/rand/fn.thread_rng.html).
In this case, I'm using a [slice](https://doc.rust-lang.org/std/slice/) instead of a vector. The main difference is, that the slice has a fixed size while the vector does not.

Within the standard library, Rust doesn't have a `sample` or `choose` method on the slice itself. 
That's a design decision: the core of the language is kept small to allow evolving the language in the future.

This doesn't mean that you cannot have a nicer implementation today.
For instance, you could define a `Choose` [trait](https://doc.rust-lang.org/book/second-edition/ch10-00-generics.html) and implement it for `[T]`.


<a class="example" href="https://play.rust-lang.org/?gist=a66785b44094bacb78fa8dd822bfeab5&version=stable">
<div class="rust icon"></div>

```rust
extern crate rand;
use rand::{thread_rng, Rng};

trait Choose<T> {
    fn choose(&self) -> Option<&T>;
}

impl<T> Choose<T> for [T] {
    fn choose(&self) -> Option<&T> {
        let mut rng = thread_rng();
        rng.choose(&self)
    }
}
```
</a>

This boilerplate could be put into a crate to make it reusable for others.
With that, we get to a solution that rivals Ruby's elegance.

<a class="example" href="https://play.rust-lang.org/?gist=a66785b44094bacb78fa8dd822bfeab5&version=stable">
<div class="rust icon"></div>

```rust
[1, 2, 4, 8, 16, 32].choose()
```
</a>


### Implicit returns and expressions

Ruby methods automatically return the result of the last statement.

<a class="example" href="https://gist.github.com/LeandroTk/9ede60f0898979f8f74d2869ed014c0c#file-return_2-rb">
<div class="ruby icon"></div>

```ruby
def get_user_ids(users)
  users.map(&:id)
end
```
</a>

Same for Rust. Note the missing semicolon.

<a class="example" href="https://play.rust-lang.org/?gist=c7130debb2f712269380bd04819069ff&version=stable">
<div class="rust icon"></div>

```rust
fn get_user_ids(users: &[User]) -> Vec<u64> {
    users.iter().map(|user| user.id).collect()
}
```
</a>

But in Rust, this is just the beginning, because everything is an expression.
This block splits a string into characters, removes the `h`, and returns the result as a `HashSet`.
This `HashSet` will be assigned to `x`.

<a class="example" href="https://play.rust-lang.org/?gist=9ad54a58d3e5f1c06e795b5f7dca451e&version=stable">
<div class="rust icon"></div>

```rust
let x: HashSet<_> = {
    // Get unique chars of a word {'h', 'e', 'l', 'o'}
    let unique = "hello".chars();
    // filter out the 'h'
    unique.filter(|&char| char != 'h').collect()
};
```
</a>

Same works for conditions:

<a class="example" href="https://play.rust-lang.org/?gist=cec96176079e8812ff62ad84a432ac9d&version=stable">
<div class="rust icon"></div>

```rust
let x = if 1 > 0 { "absolutely!" } else { "no seriously" };
```
</a>


Although, you would usually use a [`match`](https://doc.rust-lang.org/1.2.0/book/match.html) statement for that.

<a class="example" href="https://play.rust-lang.org/?gist=1f0e909fbac9632c057c49a1f981db6a&version=stable">
<div class="rust icon"></div>

```rust
let x = match 1 > 0 {
    true => "absolutely!",
    false => "no seriously",
};
```
</a>

### Multiple Assignments

In Ruby you can assign multiple values to variables in one step:

<a class="example" href="https://gist.github.com/LeandroTk/998bed8f8c20e487a1b8a638dd7563a1#file-multiple_assignment_1-rb">
<div class="ruby icon"></div>

```ruby
def values
  [1, 2, 3]
end

one, two, three = values
```
</a>

In Rust, you can only decompose tuples into tuples, but not a vector into a tuple for example.
So this will work:

<a class="example" href="https://play.rust-lang.org/?gist=11b02c318ec35456b8247c3161cb341b&version=nightly">
<div class="rust icon"></div>

```rust
let (one, two, three) = (1, 2, 3);
```
</a>

But this won't:

<a class="example" href="https://play.rust-lang.org/?gist=11b02c318ec35456b8247c3161cb341b&version=nightly">
<div class="rust icon"></div>

```rust
let (one, two, three) = [1, 2, 3];
//    ^^^^^^^^^^^^^^^^^ expected array of 3 elements, found tuple
```
</a>

Neither will this:

<a class="example" href="https://play.rust-lang.org/?gist=11b02c318ec35456b8247c3161cb341b&version=nightly">
<div class="rust icon"></div>

```rust
let (one, two, three) = [1, 2, 3].iter().collect();
// a collection of type `(_, _, _)` cannot be built from an iterator over elements of type `&{integer}`
```
</a>

But with nightly Rust, you can now do this:

<a class="example" href="https://play.rust-lang.org/?gist=11b02c318ec35456b8247c3161cb341b&version=nightly">
<div class="rust icon"></div>

```rust
let [one, two, three] = [1, 2, 3];
```
</a>

On the other hand, there's [a lot more you can do with destructuring](https://doc.rust-lang.org/book/second-edition/ch18-03-pattern-syntax.html) apart from multiple assignments. You can write beautiful, ergonomic code using pattern syntax.

<a class="example" href="https://play.rust-lang.org/?gist=969612861bc6028e3b98345e21a4289e&version=stable">
<div class="rust icon"></div>

```rust
let x = 4;
let y = false;

match x {
    4 | 5 | 6 if y => println!("yes"),
    _ => println!("no"),
}
```
</a>

> This prints `no` since the if condition applies to the whole pattern `4 | 5 | 6`, not only to the last value 6  
> &mdash; from [The Book](https://doc.rust-lang.org/book/second-edition/ch18-03-pattern-syntax.html)

### String interpolation

<a class="example" href="https://gist.github.com/LeandroTk/5125cab5e74d26460124c786ac5df534#file-interpolation-rb">
<div class="ruby icon"></div>

```ruby
programming_language = "Ruby"
"#{programming_language} is a beautiful programming language"
```
</a>

This can be translated like so:

<a class="example" href="https://play.rust-lang.org/?gist=6920e723137e44c4befe3398721fafa1&version=stable">
<div class="rust icon"></div>

```rust
let programming_language = "Rust";
format!("{} is also a beautiful programming language", programming_language);
```
</a>

Named arguments are also possible, but much less common:

<a class="example" href="https://play.rust-lang.org/?gist=6920e723137e44c4befe3398721fafa1&version=stable">
<div class="rust icon"></div>

```rust
println!("{language} is also a beautiful programming language", language="Rust");
```
</a>

The major difference is, that Rust is more leaning towards the C-style `printf` family of functions here.

### That’s it!

The rest of the examples of the [original article]( https://medium.com/the-renaissance-developer/idiomatic-ruby-1b5fa1445098 
) are quite Ruby-specific in my opinion.
Therefore I left them out. 

Ruby comes with syntactic sugar for many common usage patterns, which allows for very elegant code.
Low-level programming and raw performance are no primary goals of the language.

If you do need that, Rust might be a good fit, because it provides fine-grained hardware control with comparable ergonomics.
If in doubt, Rust favors explicitness, though. Rust eschews magic.

Did I wet your appetite for idiomatic Rust? Have a look at [this Github project](https://github.com/mre/idiomatic-rust). I'd be thankful for contributions.


### Footnotes

<sup id="fn1">1. Thanks to <a href="https://twitter.com/Argorak">Florian Gilcher</a> for the hint.<a href="#ref1" title="Jump back to footnote 1 in the text.">↩</a></sup>