extends: default.liquid

title:      Of Boxes and Trees - Smart Pointers in Rust
date:       12 Jul 2017 00:00:00 +0000
humandate:  12th of July 2017
path:       2017/boxes-and-trees
---

A few weeks ago I tried to implement a tree datastructure in Rust.
I started with this Python implementation, which it's quite straightforward.

```python
class Tree:
  def __init__(self, val, left=None, right=None):
    self.val, self.left, self.right = val, left, right
```

A tree is a recursive datastructure with a root value, a left and a right child.
This allows us to create a fancy tree like this:

```python
t = Tree(15,
      Tree(12,
           None,
           Tree(13)),
      Tree(22,
           Tree(18),
           Tree(100)))
```

And the result can be visualized beautifully. (Yes I've drawn that myself.)

<img src="/img/posts/2017/boxes-and-trees/tree.svg" alt="A binary search tree representing our datastructure"/>

Porting that code to Rust turned out to be a little... challenging.
My first attempt looked quite innocuous.

```rust
struct Tree {
    root: f64,
    left: Tree,
    right: Tree,
}
```

`rustc` did not like that:

```rust
error[E0072]: recursive type `Tree` has infinite size
 --> src/main.rs:1:1
  |
1 | struct Tree {
  | ^^^^^^^^^^^ recursive type has infinite size
  |
  = help: insert indirection (e.g., a `Box`, `Rc`, or `&`) at some point to make `Tree` representable
```

Now that's strange. Coming from dynamic languages, you might stumble over this; just like I did.

### The stack and the heap

There are two main areas of memory: the stack and the heap.



### Why did it work in Python?

Now you might be wondering why our dynamic tree worked in Python without any issues.
The reason is that Python dynamically allocates memory for the tree object at runtime.
Does that ring a bell? Yes, dynamic memory goes on the heap.
So inherently there's no difference between Rust and Python here.
Both use some kind of smart pointer.
It's just that Rust is more explicit here. Or it gives you more flexibility to express your needs.
Depending on how you look at it.


https://stackoverflow.com/a/25296420/270334

<figure>
<img src="/img/posts/2017/boxes-and-trees/treebox.svg" alt="Drawing of a cardboard box containing trees"/>
  <figcaption>
  Illustration provided by <a href="http://www.freepik.com/free-vector/green-trees_794232.htm">Freepik.com</a>.
  </figcaption>
</figure>



