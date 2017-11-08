# A Hackathon with Rust

At trivago's recent Hackathon I wanted to try something completely new.

You can read the details at trivago's own techblog.
Instead of repeating that, I specifcally want to talk about the technical challenges using Rust for the Hackathon here.

### Rust for a Hackathon - the good

What is mostly an afterthought in other languages is front end center in Rust: error handling.
This might sound tedious, but in fact it's not.
Error handling ❤️
https://github.com/rust-lang-nursery/error-chain

This is how I parsed my record entries:

```rust
fn parse_entry_record(fields: &[String]) -> Result<Record> {
    Ok(Record {
        level: fields[0].parse::<u64>()?,
        function_nr: fields[1].parse::<u64>()?,
        record_type: RecordType::Entry,
        time_index: fields[3].parse::<f64>().ok(),
        memory_usage: fields[4].parse::<u64>().ok(),
        function_name: Some(fields[5].clone()),
        internal_function: Some(fields[6].parse::<u8>()? == 0),
        include_filename: Some(fields[7].clone()),
        filename: Some(fields[8].clone()),
        line_number: Some(fields[9].parse::<u64>()?),
        num_params: Some(fields[10].parse::<u64>()?),
        params: fields[11..].iter().map(|e| get_param_type(e)).collect(),
    })
}
```
I'd like to highlight two things:

```rust
    internal_function: Some(fields[6].parse::<u8>()? == 0),
    params: fields[11..].iter().map(|e| get_param_type(e)).collect(),
```

In hindsight, I should have used three different types for that.
This way, I could have avoided all the optional parameters (the ones starting with `Option`)



I noticed, that I still create a lot of `clone` values, pass by value, owned types during prototyping.
Only later I clean up and replace pass by value with references.
It's good to know that this is not killing performance.
still unbelievably fast (parses 100s of MBs per second)
Especially in release mode.


Clippy

```
warning: you seem to be trying to match on a boolean expression
  --> src/linecount.rs:46:25
   |
46 |               .map(|line| match lines.contains(&line) {
   |  _________________________^
47 | |                 true => 1,
48 | |                 false => 0,
49 | |             })
   | |_____________^ help: consider using an if/else expression: `if lines.contains(&line) { 1 } else { 0 }`
```


```
    hitcount_map
        .entry(file_path)
        .or_insert_with(|| LineHitSet::new())
        .insert(line_number);
```

```
warning: redundant closure found
  --> src/linecount.rs:38:29
   |
38 |             .or_insert_with(|| LineHitSet::new())
   |                             ^^^^^^^^^^^^^^^^^^^^ help: remove closure as shown: `LineHitSet::new`
   |
```

```
    hitcount_map
        .entry(file_path)
        .or_insert_with(LineHitSet::new)
        .insert(line_number);
```


### Neutral observations

Sometimes I was not happy with a piece of code and I spent more time than required to make it more idiomatic.
I took it as a learning experience.
I noticed that I do this more ofen in Rust compared to Golang for example.
My guess is, that Rust is just the more powerful language and it's fun to explore better ways to do things.
In Golang, I'm mostly focused to get stuff done, in Rust I can feel how I become a better developer.

Example: Merge/zip hashmaps
Simple solution
Complex solution with zip_longest from itertools




### Rust for a Hackathon - the bad

I had some issues converting between `Option` and `Result`.
I knew that it was possible, but getting the conversion *just* right was tricky.
[EXAMPLE HERE]


Package management got in the way.
Extern-crate, mod, use,... I really think there should be a simpler way to handle dependencies.
Making things public inside the own crate is kind of a hassle.
Especially during protoyping this can be a pain.

### Rust for a Hackathon - the (not so) ugly

Using the MongoDB driver was an interesting experience. Before I only used it with dynamically typed languages.
Sometimes it felt like I had to work around the type system to store data as pure JSON.
I know that this could be done more elegantly with serde, or maybe by using the json!() macro that was provided, but given the tight timeframe, I tried to "hack" it.