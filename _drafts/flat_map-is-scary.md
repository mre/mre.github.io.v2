data:
  translations: ~
  humandate: ~
  social_img: ~
  css: ~
  subtitle: ""
  comments: ~
---
```rust
fn main() {
    let meta = vec!["bla=blub,x=y", "foo=bar"];
    let pairs: Vec<&str> = meta.iter().map(|pairs| pairs.split(',')).collect();
    println!("{:#?}", pairs);
}
```

```
  Compiling playground v0.0.1 (file:///playground)
error[E0277]: the trait bound `std::vec::Vec<&str>: std::iter::FromIterator<std::str::Split<'_, char>>` is not satisfied
 --> src/main.rs:3:70
  |
3 |     let pairs: Vec<&str> = meta.iter().map(|pairs| pairs.split(',')).collect();
  |                                                                      ^^^^^^^ a collection of type `std::vec::Vec<&str>` cannot be built from an iterator over elements of type `std::str::Split<'_, char>`
  |
  = help: the trait `std::iter::FromIterator<std::str::Split<'_, char>>` is not implemented for `std::vec::Vec<&str>`

error: aborting due to previous error

error: Could not compile `playground`.
```


```rust
fn main() {
    let meta = vec!["bla=blub,x=y", "foo=bar"];
    let pairs: Vec<&str> = meta.iter().flat_map(|pairs| pairs.split(',')).collect();
    println!("{:#?}", pairs);
}
```

```
[
    "bla=blub",
    "x=y",
    "foo=bar"
]
```


