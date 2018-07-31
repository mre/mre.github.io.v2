extends: default.liquid

title:      fastcat - A Faster `cat` Implementation Using Splice
date:       31 Jul 2018 00:00:00 +0000
humandate:  31st of July 2018
path:       2018/fastcat
excerpt:    Lots of people asked me to write another piece about the internals of well-known
            Unix commands. Well, actually, nobody asked me, but it makes for a good
            intro. I'm sure you’ve read the previous parts about [`yes`](/2017/yes) and
            [`ls`](/2018/ls/) &mdash; they are awesome.

            Anyway, today we talk about `cat`, which is used to concatenate files - or, more
            commonly, abused to print a file's contents to the screen.
---

![fastcat logo](/img/posts/2018/fastcat/fastcat.svg)

Lots of people asked me to write another piece about the internals of well-known
Unix commands. Well, actually, nobody asked me, but it makes for a good
intro. I'm sure you’ve read the previous parts about [`yes`](/2017/yes) and
[`ls`](/2018/ls/) &mdash; they are awesome.

Anyway, today we talk about `cat`, which is used to concatenate files - or, more
commonly, abused to print a file's contents to the screen.

```sh
# Concatenate files, the intended purpose
cat input1.txt input2.txt input3.txt > output.txt

# Print file to screen, the most common use case
cat myfile
```


### Implementing cat

Here's a simple `cat` in Ruby:

```ruby
#!/usr/bin/env ruby

def cat(args)
  args.each{|arg|
        unless File.exists?(arg)
            puts "#{arg}: No such file or directory"
            next
        end
        IO.foreach(arg){|line|
            puts line
        }
    }
end
cat(ARGV)
```

This program goes through each file and prints its contents line by line.
Easy peasy! But wait, how fast is this tool?

So I quickly created a random 2GB file for the benchmark.

I'll compare the speed of our naive implementation with the system one
using the awesome [pv](http://www.ivarch.com/programs/pv.shtml) (Pipe Viewer) tool.
All tests are averaged over five runs on a warm cache (file in memory).

```
# Ruby 2.5.1
> ./rubycat myfile | pv -r > /dev/null
[196MiB/s]
```

Not bad, I guess?
How does it compare with my system's cat?

```
cat myfile | pv -r > /dev/null
[1.90GiB/s]
```

Uh oh, GNU cat is **ten times faster** than our little Ruby cat. 🐌

## Making our `cat` a little faster

Here's a Rust version with a few tricks up its sleeve
(you could do the same things with Ruby, by the way. 😉):

```rust
use std::env;
use std::fs::File;
use std::io::{self, BufReader, Read, Write};

pub const BUFFER_CAPACITY: usize = 64 * 1024;

fn main() -> Result<(), io::Error> {
    for path in env::args().skip(1) {
        let stdout = io::stdout();
        let mut locked = stdout.lock();
        let mut buffer = [0u8; BUFFER_CAPACITY];

        let input = File::open(path)?;
        let mut buffered = BufReader::new(input);

        loop {
            let bytes_read = buffered.read(&mut buffer)?;
            if bytes_read == 0 {
                    break;
            }
            locked.write_all(&buffer)?;
        }
    }
    Ok(())
}
```

* Since our application is I/O-bound and single-threaded, we lock standard out
  so that we don't waste precious time to acquire a Mutex.
* We use a buffer to read 64kb from the input file at once.

Let's see how far these tricks get us:

```
cat_rust myfile | pv -r > /dev/null
[1.21GiB/s]
```

Our Rust is as fast as GNU cat and only 40% slower than BSD cat.
Time to celebrate, right?
Hum... we didn't really try hard, and we're already approaching the speed
of a tool that has been around [since
1971](https://en.wikipedia.org/wiki/Cat_(Unix)).

Can we go faster?

### Splice

What initially motivated me to write about `cat` was [this comment by user
wahern on
HackerNews](https://news.ycombinator.com/item?id=15455897):

> I'm surprised that neither GNU yes nor GNU cat uses splice(2).

Could this *splice* thing make printing files even faster? &mdash; I was intrigued.

Splice was first introduced to the Linux Kernel in 2006, and there is a nice
[summary from Linus Torvalds himself](https://web.archive.org/web/20130305002825/http://kerneltrap.org/node/6505),
but I prefer the description from the [manpage](http://man7.org/linux/man-pages/man2/splice.2.html):

> **splice()** moves data between two file descriptors without copying
> between kernel address space and user address space.  It transfers up
> to len bytes of data from the file descriptor fd_in to the file
> descriptor fd_out, where one of the file descriptors must refer to a
> pipe.

If you really want to dig deeper, here's the corresponding [source code from the
Linux Kernel](
https://github.com/torvalds/linux/blob/6ed0529fef09f50ef41d396cb55c5519e4936b16/fs/splice.c),
but we don't need to know all the nitty-gritty details for now.
Instead, we can just inspect the [header from the C implementation](http://www.sourcexr.com/articles/2014/02/23/avoid-data-copy-with-splice):

```C
#include <fcntl.h>

ssize_t splice (int fd_in, loff_t *off_in, int fd_out,
                loff_t *off_out, size_t len,
                unsigned int flags);
```

To break it down even more, here's how we would copy the entire `src` file to `dst`:

```C
const ssize_t r = splice (src, NULL, dst, NULL, size, 0);
```

The cool thing about this is that all of it happens inside the Linux kernel, which means we won't copy a single byte to userspace (where our program runs).
Ideally, splice works by remapping pages and does not actually copy
any data, which may improve I/O performance
([reference](https://en.wikipedia.org/wiki/Splice_(system_call))).

<figure>
    <img src="/img/posts/2018/fastcat/buffers.png" />
  <figcaption>
File icon by Aleksandr Vector from the Noun Project.<br />
terminal icon by useiconic.com from the Noun Project.
  </figcaption>
</figure>

I have to say I'm not a C programmer and I prefer Rust because it offers a safer
interface. Here's the same thing in Rust:

```rust
#[cfg(any(target_os = "linux", target_os = "android"))]
pub fn splice(fd_in: RawFd, off_in: Option<&mut libc::loff_t>,
              fd_out: RawFd, off_out: Option<&mut libc::loff_t>,
              len: usize, flags: SpliceFFlags) -> Result<usize>
```

See those `target_os` flags? That's Rusts way of saying "I can only compile that
for Linux and Android (a Linux flavor).
[It seems
like](https://stackoverflow.com/questions/12230316/do-other-operating-systems-implement-the-linux-system-call-splice?lq=1)
OpenBSD also has some sort of splice implementation called
[`sosplice`](http://man.openbsd.org/sosplice). I haven't tested that, though. On
mac OS, the closest thing to splice (and its bigger brother,
[sendfile](https://linux.die.net/man/2/sendfile)) is called [`copyfile`](
https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man3/copyfile.3.html).
It has a similar interface, but unfortunately, it is not zero-copy. (I thought so
in the beginning, but [I was
wrong](https://github.com/rust-lang/libc/pull/886).)

Other Operating Systems don't provide zero-copy file transfer it seems (though I
hope I'm wrong). Nevertheless, in a production-grade implementation, the splice
support could be activated on systems that support it, while using a generic
implementation as a fallback.


### Using splice from Rust

I haven't implemented the Linux bindings myself. Instead, I just use a library called
[nix](https://github.com/nix-rust/nix), which provides Rust friendly bindings to *nix APIs.

There is one caveat:
We cannot really copy the file directly to standard out, because splice
requires one file descriptor to be a pipe.
The way around that is to create a pipe, which consists of a reader and a
writer (`rd` and `wr`).
We pipe the file into the writer, and then we read from the pipe and push the data to stdout.

You can see that I use a relatively big buffer of 16384 bytes (2^14) to improve performance.

```rust
extern crate nix;

use std::env;
use std::fs::File;
use std::io;
use std::os::unix::io::AsRawFd;

use nix::fcntl::{splice, SpliceFFlags};
use nix::unistd::pipe;

fn main() {
    for path in env::args().skip(1) {
        let input = File::open(&path).expect(&format!("fcat: {}: No such file or directory", path));
        let (rd, wr) = pipe().unwrap();
        let stdout = io::stdout();
        let _handle = stdout.lock();

        loop {
            let res = splice(
                input.as_raw_fd(),
                None,
                wr,
                None,
                16384,
                SpliceFFlags::empty(),
            ).unwrap();

            if res == 0 {
                // We read 0 bytes from the input,
                // which means we're done copying.
                break;
            }

            let _res = splice(
                rd,
                None,
                stdout.as_raw_fd(),
                None,
                16384,
                SpliceFFlags::empty(),
            ).unwrap();
        }
    }
}
```

So, how fast is this?

```
fcat myfile | pv -r > /dev/null
[5.90GiB/s]
```

Holy guacamole. That's **over three times as fast as system cat**.

### Why on earth would I want that?

I have no idea.
Probably you don't, because your bottleneck is somewhere else.

That said, many people use `cat` for piping data into another process, e.g.

```sh
# Count all lines in C files
cat *.c | wc -l
```

or

```sh
cat kitty.txt | grep "dog"
```


In this case, if you notice that `cat` is the bottleneck try `fcat`.

With some more work, `fcat` could also be used to directly route packets from one
network card to another, [similar to netcat](http://nc110.sourceforge.net/). 

# Lessons learned

* The closer we get to the bare metal, the more our hard-won abstractions fall
  apart and we are back to low level systems programming.
* Apart from a fast cat, there's also a use-case for a slow cat: old computers.
  For that purpose, there's... well.. [slowcat](https://grox.net/software/mine/slowcat/).
  
That said, I still have no idea why GNU cat does not use splice on Linux. 🤔
The [source code for fcat is on Github](https://github.com/mre/fcat).
Contributions welcome!

**Thanks** to [Olaf Gladis](https://twitter.com/hwmrocker) for helping me run the benchmarks on his Linux machine and to [Patrick Pokatilo](https://github.com/SHyx0rmZ) and [Simon Brüggen](https://github.com/m3t0r) for reviewing drafts of the article.


