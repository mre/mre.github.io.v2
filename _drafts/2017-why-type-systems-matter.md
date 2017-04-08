extends: default.liquid

title:      Why Type Systems matter
date:       18 Mar 2017 00:00:00 +0000
humandate:  18th of March 2017
path:       2017/why-type-systems-matter
---

This is a practical guide to type systems.
The focus is on *concrete examples*


### Simple exampmles

Types express intent.
They hold information.

With types you communicate your guarantees and expectations. Not only to a
machine, but also to other humans.

As a programmer, you probably gained some intuition about types.

```python
filesize = "5000" # Size in bytes
```

Here, we express a file size as a string.
While this will compile and run, it is cumbersome to work with this type.
For instance, simple calculations might lead to unexpected results:  

```python
file1 = "5000"
file2 = "3000"
total = file1 + file2
print(total) # prints '50003000'
```

We can assume that a file size is always a number.
To be even more precise, it must be a *positive, natural number*.
There can be no negative file size and our smallest unit is one byte
(in all but the most exotic cases).
And since we're dealing with a discrete machine here, we know it can only be
size for a file that the machine can handle.
If we could only express this intent in a concise way...
This is where a type system comes in handy.

In Rust you could have a type `File` with a field `size`:
```
```
struct File {
  name: String,
  size: size_t (TODO fix type)
}
```

Notice that there is no more ambiguity, no arbitrariness.
You can not create an invalid file object:

```
let weird_file = File { name: 123, size: "hello" };
```

The type system will not allow invalid state. It will simply not *allow* you to
break your own rules. It will hold you accountable for your design choices.
Dare I say it: it becomes an extension of your brain.
After some time you start to rely on the type checker. If it compiles, it runs
is a powerful mantra.


Consider the following snippet:

```python
def filter(files):
  matches = []
  for file in files:
    if file.status == 1:
      matches.append(file)
  return matches
```

We are missing the *intent* behind this function.
What does `1` represent?
Without additional context, we can't say.

The story gets a little clearer once we define a type like this:

```python
from enum import Enum

class FileStatus(Enum):
  OPEN = 0
  CLOSED = 1
```

Our example from above becomes

```python
def filter(files):
  matches = []
  for file in files:
    if file.status == FileStatus.CLOSED:
      matches.append(file)
  return matches
```

In a larger codebase, `FileStatus.CLOSED` is much easier to grep for than `7`.


> Don't think of types as constraints, think of them as a way to express your
thoughts more precicely. A type system can guide you towards the ideal
representation of your data.

For instance, is the order of returned files irrelevant?
Do we need to check later if a file was filtered out?
If so, then you should consider using a set`instead of a `list`.
Always use the type that precicely fits your requirements.
If there is none in the standard library, create your own from simpler types.

FOOTNOTE(The native enum type was introduced very late in the history of Python. It serves as a nice
example of how enhancing the type system can help improve readability)




### Where type systems really shine

> When you combine different types in your program,  magic happens.

All pieces suddenly fall into place. Out of nowhere, the compiler will start
checking your type decisions in if all types work well together. It will point out gaps in your logic
and flaws in your mental model.
This helps a ton with refactoring.


### Dynamic Type Systems

### Type inference

Some powerful languages allow you to skip the type delcarations as long as
there a no contradictions. That's called "type infrence". It's pretty helpful when you haven't
figured out the best way to represent your data yet &mdash; for example while
working on a prototype.
It saves a lot of typing work and makes to code more readable.

The following two snippets generate the same machine code:


TODO: Example




