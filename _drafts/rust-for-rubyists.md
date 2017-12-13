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


The above Ruby code can be more simplified like this:

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
If you want a collection, you would have to [run `collect()` on that](https://doc.rust-lang.org/std/iter/trait.Iterator.html#examples-23).


### Select and filter

The article goes on to demonstrate Ruby's `select` method:

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

* I'm using a type hint (`Vec<i64>`) here, because without it Rust does not know what collection I want to build when calling `collect`.
* `vec!` is a macro, which creates a preallocated vector at compile time.
* Instead of `iter` I use `into_iter` for a change. This way, I take ownership of the elements in the vector. With `iter()` I would get a `Vec<&i64>` instead.

In Rust, there is no `even` method defined on numbers, but that doesn't keep you from defining one.

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


I told you before, that Rust does not have `nil`. However there is still the concept of operations that can fail.
It's called a [`Result`](https://doc.rust-lang.org/std/result/).
That's pretty handy when you have operations that can fail.

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
An easy way to filter out the errors is by using `filter_map`:

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
* Since `filter_map` expects a predicate to filter on, I convert the `Result` return value of `parse` into a boolean.

The result is as simple as

```rust
[1, 2, 3]
```

The `filter_map` is similar to the `select` method in Ruby:

```ruby
[1, 2, 3, 4, 5].select { |element| element.even? }
```

```
```


https://medium.com/the-renaissance-developer/idiomatic-ruby-1b5fa1445098