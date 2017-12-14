extends: default.liquid

title:      Rust for Rubyists
date:       14 Dec 2017 00:00:00 +0000
humandate:  14th of Dezember 2017
path:       2017/rust-for-rubyists
draft: true
---

Recently I read [a nice article on idiomatic Ruby](https://medium.com/the-renaissance-developer/idiomatic-ruby-1b5fa1445098) and I realized, that a lot of the patterns mentioned would also be considered idiomatic Rust.  

And I thought: "Hey, why not write an article about comparing both languages?".
I don't want to imply that any of the languages is superiour. Quite the contrary: they're best friends.


### Map

The first example in the article is a pretty common iteration over elements in a container using `map`.

```ruby
user_ids = users.map { |user| user.id }
```

The `map` concept is also pretty common in Rust.
Compared to Ruby, we need to be a little more explicit here:
If `users` is a vector of `user` structs, we first need to create an iterator from it:

```rust
let user_ids = users.iter().map(| user| user.id );
```
[Edit](https://play.rust-lang.org/?gist=5a61b7b44ff01fabbc07dba9409d9b97&version=stable)
[Gist](https://gist.github.com/5a61b7b44ff01fabbc07dba9409d9b97)

You might say that's quite verbose, but this additional abstraction allows us to express an important concept:
will the iterator take ownership of the vector, or will it not?

* With `iter()`, you get a "read only view" into the vector. After the iteration it will be unchanged.
* With `into_iter()`, you take ownership over the vector. After the iteration the vector will be gone.
  In Rust terminology, it will have "moved".

Read some more about the [difference between `iter()` and `into_iter()` here](http://hermanradtke.com/2015/06/22/effectively-using-iterators-in-rust.html).


The above Ruby code can be simplified like this:

```ruby
user_ids = users.map(&:id)
```

Something similar can be done in Rust:

```rust
let user_ids = users.iter().map(id);
```

I'm cheating a little bit here, because I omit a critical piece &mdash; creating a closure to extract the field from each item.
It could look like this:

```rust
let id = |u: &User| u.id;
```
[Edit](https://play.rust-lang.org/?gist=131027a481d4691821315ad308d26dc9&version=stable)
[Gist](https://gist.github.com/131027a481d4691821315ad308d26dc9)

That's quite verbose of course, but it's a nice trick and if you access the `id` more often, it might pay off to define that closue.

Also note, that `map()` returns another iterator and not a collection.
If you want a collection, you would have to [run `collect()` on that](https://doc.rust-lang.org/std/iter/trait.Iterator.html#examples-23), as we'll see later.

### Each

Speaking about iteration, one pattern that I see a lot in Ruby code is this:

```ruby
["Ruby", "Rust", "Python", "Cobol"].each do |lang|
  puts "Hello #{lang}!"
end
```

Since [Rust 1.21](https://blog.rust-lang.org/2017/10/12/Rust-1.21.html), this is now also possible:

```rust
["Ruby", "Rust", "Python", "Cobol"]
    .iter()
    .for_each(|lang| println!("Hello {lang}!", lang = lang));
```
https://play.rust-lang.org/?gist=549d38bc43549fd5444c731d2bc3a47b&version=stable

Although, more commonly one would write that as a normal for-loop in Rust:

```rust
for lang in ["Ruby", "Rust", "Python", "Cobol"].iter() {
    println!("Hello {lang}!", lang = lang);
}
```
https://play.rust-lang.org/?gist=a7691b56b1dfd1fb19aa00a91b39589d&version=stable


### Select and filter

Let's say you want to extract only even numbers from a collection in Ruby.

```ruby
even_numbers = [1, 2, 3, 4, 5].map { |element| element if element.even? } # [ni, 2, nil, 4, nil]
even_numbers = even_numbers.compact # [2, 4]
```

In this example, before calling `compact`, our `even_numbers` array had `nil` entries.
Well, in Rust there is no concept of `nil` or `Null`. You don't need a `compact`.
Also, `map` doesn't take predicates. You would use `filter` for that:

```rust
let even_numbers = vec![1, 2, 3, 4, 5]
    .iter()
    .filter(|&element| element % 2 == 0);
```

[Edit](https://play.rust-lang.org/?gist=494d6e3ff016c21931e3495b10c8f6ee&version=stable)
[Gist](https://gist.github.com/494d6e3ff016c21931e3495b10c8f6ee)

or, to make a vector out of the result

```rust
// Result: [2, 4]
let even_numbers: Vec<i64> = vec![1, 2, 3, 4, 5]
    .into_iter()
    .filter(|element| element % 2 == 0).collect();
```

[Edit](https://play.rust-lang.org/?gist=45c6dbd2d35316c73165c5571d66df9d&version=stable)
[Gist](https://gist.github.com/45c6dbd2d35316c73165c5571d66df9d)

Some hints:

* I'm using a type hint (`Vec<i64>`) here, because without it, Rust does not know what collection I want to build when calling `collect`.
* `vec!` is a macro, which creates a preallocated vector at compile time.
* Instead of `iter` I use `into_iter` for a change. This way, I take ownership of the elements in the vector. With `iter()` I would get a `Vec<&i64>` instead.

In Rust, there is no `even` method on numbers, but that doesn't keep you from defining one.

```rust
let even = |x: &i64| x % 2 == 0;
let even_numbers = vec![1, 2, 3, 4, 5].into_iter().filter(even);
```
[Edit](https://play.rust-lang.org/?gist=c289c2a1cf8bd870cbd5cc2cd60ea791&version=stable)
[Gist](https://gist.github.com/c289c2a1cf8bd870cbd5cc2cd60ea791)


In a real-world scenario, you would probably use crates like [`num`](https://github.com/rust-num/num) for numerical mathematics:

```rust
extern crate num;
use num::Integer;

fn main() {
    let even_numbers: Vec<i64> = vec![1, 2, 3, 4, 5]
        .into_iter()
        .filter(|x| x.is_even()).collect();
}
```
[Edit](https://play.rust-lang.org/?gist=e4bbbf60b7b1cbbedfb363672731bf53&version=stable)
[Gist](https://gist.github.com/e4bbbf60b7b1cbbedfb363672731bf53)


I mentioned before, that Rust does not have `nil`. However there is still the concept of operations that can fail.
The type is called [`Result`](https://doc.rust-lang.org/std/result/).

Let's say you want to convert a vector of strings to integers.

```rust
let maybe_numbers = vec!["1", "2", "nah", "nope", "3"];
let numbers: Vec<_> = maybe_numbers
    .into_iter()
    .map(|i| i.parse::<u64>())
    .collect();
```
[Edit](https://play.rust-lang.org/?gist=1365d177503ee2d32c4aa594263ee4d4&version=stable)
[Gist](https://gist.github.com/1365d177503ee2d32c4aa594263ee4d4)

That looks nice, but maybe the output is a little unexpected. `numbers` will also contain the parsing errors:

```rust
[Ok(1), Ok(2), Err(ParseIntError { kind: InvalidDigit }), Err(ParseIntError { kind: InvalidDigit }), Ok(3)]
```

Sometimes you're just interested in the successful results.
An easy way to filter out the errors is by using [`filter_map`](https://doc.rust-lang.org/std/iter/trait.Iterator.html#method.filter_map):

```rust
let maybe_numbers = vec!["1", "2", "nah", "nope", "3"];
let numbers: Vec<_> = maybe_numbers
    .into_iter()
    .filter_map(|i| i.parse::<u64>().ok())
    .collect();
```
[Edit](https://play.rust-lang.org/?gist=afdc823ec2e165ac0a03948fb323d305&version=stable)
[Gist](https://gist.github.com/afdc823ec2e165ac0a03948fb323d305)

I changed two things here:

* Instead of `map` I'm now using `filter_map`
* Since `filter_map` expects a predicate to filter on, I convert the `Result` return value of `parse` into a boolean by calling `ok()` on it.

The result is as simple as

```rust
[1, 2, 3]
```

The `filter_map` is similar to the `select` method in Ruby:

```ruby
[1, 2, 3, 4, 5].select { |element| element.even? }
```

<figure>
    <object data="/img/posts/2017/rust-for-rubyists/crab.svg" type="image/svg+xml"></object>
  <figcaption>
Icon adapted from <a href="http://freepik.com/">FreePik</a> from <a href="https://www.flaticon.com/free-icon/crab-cancer-symbol_47210">
www.flaticon.com</a>
  </figcaption>
</figure>


### Random numbers


Next up, the article describes how to get a random number from an array:

```ruby
[1, 2, 3].sample
```

That's quite nice and idiomatic!
Compare that to Rust:

```rust
    let mut rng = thread_rng();
    rng.choose(&[1, 2, 3, 4, 5])
}
```
https://play.rust-lang.org/?gist=bed7fca31737bcbf4b9aed427cc22713&version=stable
https://gist.github.com/bed7fca31737bcbf4b9aed427cc22713

For the code to work, you need the `rand` crate. See the link to the code snippet for a running example.

There are some differences to Ruby. Namely, we need to be more explicit about what random number generator
we want *exactly*. We decide for a [lazily-initialized thread-local random number generator, seeded by the system](https://doc.rust-lang.org/rand/rand/fn.thread_rng.html).
In this case I'm using a [slice](https://doc.rust-lang.org/std/slice/) instead of a vector. The main difference is, that the slice has a fixed size while the vector does not.

Within the standard library, we don't have a `sample` or `choose` method on the slice itself. 
That's a design decision: the core of the language is kept small to allow evolving the language in the future.

This doesn't mean that you cannot have a nicer implementation today.
For instance, you could define a `Choose` [trait](https://doc.rust-lang.org/book/second-edition/ch10-00-generics.html) and implement it for `[T]`.


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
https://play.rust-lang.org/?gist=a66785b44094bacb78fa8dd822bfeab5&version=stable
https://gist.github.com/a66785b44094bacb78fa8dd822bfeab5

This boilerplate could be put into a crate to make it reusable for others.
With that, we get to a solution that rivals Ruby's elegance.

```rust
[1, 2, 4, 8, 16, 32].choose()
```


### Implicit returns and expressions

In Ruby, you can do implicit returns.

```ruby
def get_user_ids(users)
  users.map(&:id)
end
```

Same for Rust:


```rust
fn get_user_ids(users: &[User]) -> Vec<u64> {
    users.iter().map(|user| user.id).collect()
}
```

https://play.rust-lang.org/?gist=c7130debb2f712269380bd04819069ff&version=stable
https://gist.github.com/c7130debb2f712269380bd04819069ff


But in Rust, this is just the beginning, because everything (most things) is an expression.
This block splits a string into characters, removes the `h` and returns the result as a `HashSet`.
This `HashSet` will be assigned to `x`.

```rust
let x: HashSet<_> = {
    // Get unique chars of a word {'h', 'e', 'l', 'o'}
    let unique = "hello".chars();
    // filter out the 'h'
    unique.filter(|&char| char != 'h').collect()
};
```
https://play.rust-lang.org/?gist=9ad54a58d3e5f1c06e795b5f7dca451e&version=stable

```rust
let x = if 1 > 0 { "absolutely!" } else { "no seriously" };
```

https://play.rust-lang.org/?gist=cec96176079e8812ff62ad84a432ac9d&version=stable

Although, you would usually use a `match` statement for that.

```rust
let x = match 1 > 0 {
    true => "absolutely!",
    false => "no seriously",
};
```

https://play.rust-lang.org/?gist=1f0e909fbac9632c057c49a1f981db6a&version=stable

### Multiple Assignments

Ruby: 

```ruby
def values
  [1, 2, 3]
end

one, two, three = values
```

In Rust you can only decompose tuples into tuples, but not a vector into a tuple for example.
So this will work:
```rust
let (one, two, three) = (1, 2, 3);
```

But this won't:

```rust
let (one, two, three) = [1, 2, 3];
//    ^^^^^^^^^^^^^^^^^ expected array of 3 elements, found tuple
```

Neither will this:

```rust
let (one, two, three) = [1, 2, 3].iter().collect();
// a collection of type `(_, _, _)` cannot be built from an iterator over elements of type `&{integer}`
```

With nightly Rust, you can now do this, though:

```rust
let [one, two, three] = [1, 2, 3];
```

https://play.rust-lang.org/?gist=11b02c318ec35456b8247c3161cb341b&version=nightly

On the other hand, there's [a lot more you can do with destructuring](https://doc.rust-lang.org/book/second-edition/ch18-03-pattern-syntax.html) apart from multiple assignments. You can write beautiful, ergonomic code using pattern syntax.

```
let x = 4;
let y = false;

match x {
    4 | 5 | 6 if y => println!("yes"),
    _ => println!("no"),
}
```

> This prints `no` since the if condition applies to the whole pattern `4 | 5 | 6`, not only to the last value 6 (from [the book](https://doc.rust-lang.org/book/second-edition/ch18-03-pattern-syntax.html))

### String interpolation

```ruby
programming_language = "Ruby"
"#{programming_language} is a beautiful programming language"
```

This can be translated like so:

```rust
let programming_language = "Rust";
format!("{} is also a beautiful programming language", programming_language);
```

Named arguments are also possible, but much less common:

```rust
println!("{language} is also a beautiful programming language", language="Rust");
```
https://play.rust-lang.org/?gist=6920e723137e44c4befe3398721fafa1&version=stable

The major difference is, that Rust is more leaning towards the C-style `printf` family of function.

### That’s it for today!

The rest of the examples of the [original article]( https://medium.com/the-renaissance-developer/idiomatic-ruby-1b5fa1445098 
) are quite Ruby-specific in my opinion.
Therefore I left them out. 


If I wettened your apetite for idiomatic Rust, may I suggest to have a look at [my Github project](https://github.com/mre/idiomatic-rust) around that topic? I'd be happy for contributions.