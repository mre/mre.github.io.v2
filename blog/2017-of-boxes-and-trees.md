extends: default.liquid

title:      Of Boxes and Trees - Smart Pointers in Rust
date:       12 Jul 2017 00:00:00 +0000
humandate:  12th of July 2017
path:       2017/boxes-and-trees
---

A few weeks ago, I tried to implement a binary tree datastructure in Rust.
Each binary tree has a root value, a left and a right subtree.
I started from this Python implementation, which is quite straightforward.

```python
class Tree:
  def __init__(self, val, left=None, right=None):
    self.val, self.left, self.right = val, left, right
```

This allows us to declare a fancy tree object like this:

```python
t = Tree(15,
      Tree(12,
           None,
           Tree(13)),
      Tree(22,
           Tree(18),
           Tree(100)))
```

And the result can be visualized beautifully.  
(Yes I've drawn that myself.)

<img src="/img/posts/2017/boxes-and-trees/tree.svg" alt="A binary search tree representing our datastructure"/>

Porting that code to Rust turned out to be a little... challenging.
My first attempt looked quite innocuous.

```rust
struct Tree {
    root: i64,
    left: Tree,
    right: Tree,
}
```

That's pretty much a one-to-one translation of the Python definition &mdash; but [**`rustc`** **says no**](https://www.youtube.com/watch?v=0n_Ty_72Qds).

```rust
error[E0072]: recursive type `Tree` has infinite size
 --> src/main.rs:1:1
  |
1 | struct Tree {
  | ^^^^^^^^^^^ recursive type has infinite size
  |
  = help: insert indirection (e.g., a `Box`, `Rc`, or `&`) at some point to make `Tree` representable
```

Coming from memory-managed languages, I was confused by this.
The problem is easy to understand, though.
Computers have a limited amount of memory.
It's the compiler's job to find out how much memory to allocate for each item.

In our case, it infers the following:

A tree is a structure containing an `i64`, and two trees. Each of these trees is a structure containing an `i64`, and two trees. Each of these...  
[You get the idea.](https://stackoverflow.com/a/25296420/270334)

```rust
Tree { i64, Tree, Tree }
Tree { i64, Tree { ... }, Tree { ... } }
// The next expansion won't fit on the page anymore
```

Since we don't know how many subtrees our tree will have, there is no way to tell how much memory we need to allocate upfront. We'll only know at runtime!

Rust tells us how to fix that: by inserting an *indirection*  
(e.g., a `Box`, `Rc`, or `&`).

`Box`, `Rc` and `&` are three different "pointer types" in Rust. They all point to places in memory. So, instead of knowing the total size of our tree structure, we just know the *point* in memory where the tree is located. But that's enough to define the tree structure.
These pointer types allow us to do that safely and without manual memory management.
They all offer different guarantees and you should [choose the one that fits your requirements best](/2017/why-type-systems-matter/).

* `&` is called a `borrow` in Rust speech. It's the most common of the three. It's a reference to some place in memory, but it does not **own** the data it points to. As such, the lifetime of the borrow depends on its owner.
Therefore we would need to add lifetime parameters:

```rust
struct Tree<'a> {
    root: i64,
    left: &'a Tree<'a>,
    right: &'a Tree<'a>,
}
```

* [`Box`](https://doc.rust-lang.org/std/boxed/struct.Box.html) is a **smart pointer**. It has zero runtime overhead. It owns the data it points to.
It's smart, because when it goes out of scope it will first drop the data it points to and then itself.
No manual memory management required.

```rust
struct Tree {
    root: i64,
    left: Box<Tree>,
    right: Box<Tree>,
}
```

* [`Rc`](https://doc.rust-lang.org/std/rc/struct.Rc.html) is another smart pointer. It's short for "reference-counting". It keeps track of the number of references to a datastructure. As soon as the number of references is down to zero, it cleans up after itself.

```rust
struct Tree {
    root: i64,
    left: Rc<Tree>,
    right: Rc<Tree>,
}
```

All three options are totally valid, depending on your use-case.
The rule of thumb is to stick with simple borrows as long as sensible.


For a more in-depth explanation of these types, I may refer you to [Wrapper Types in Rust: Choosing Your Guarantees](https://manishearth.github.io/blog/2015/05/27/wrapper-types-in-rust-choosing-your-guarantees/).

### Smart pointers

As usual, the [Rust documentation](https://doc.rust-lang.org/book/second-edition/ch15-00-smart-pointers.html) (commonly referred to as *the book*) provides a succinct definition:

> Pointer is a generic programming term for something that refers to a location that stores some other data.
>  
> Smart pointers are data structures that <strong><u>act like a pointer</u></strong>, but also have <strong><u>additional metadata</u></strong> and capabilities.


### Why did it work in Python?

Now you might be wondering why our tree implementation worked so flawlessly in Python.
The reason is that Python dynamically allocates memory for the tree object at runtime.
Also, it wraps everything inside a [PyObject, which is kind of similar to `Rc` from above](http://pythonextensionpatterns.readthedocs.io/en/latest/refcount.html)
&mdash; a reference counted smart pointer.

Rust is more explicit here. It gives us more flexibility to express our needs.
Then again, we need to know about all the possible alternatives to make good use of them.

<figure>
<img src="/img/posts/2017/boxes-and-trees/treebox.svg" alt="Drawing of a cardboard box containing trees"/>
  <figcaption>
  Illustration provided by <a href="http://www.freepik.com/free-vector/green-trees_794232.htm">Freepik.com</a>.
  </figcaption>
</figure>



