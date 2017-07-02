extends: default.liquid

title:      Why Type Systems matter
date:       18 Mar 2017 00:00:00 +0000
humandate:  18th of March 2017
path:       2017/why-type-systems-matter
---

This is a practical introduction to type systems.
The focus is on *concrete examples*.

### Types express intent

With types you communicate your guarantees and expectations. Both, to the machine and to other developers.

As a programmer, you probably gained some **intuition** about types.

```python
sentence = "hello world"
```

You might guess that `sentence` is a string. It's in quotes, after all. 
It gets a little more tricky if the type gets **inferred** from some other location.

```python
sentence = x
```

Is `sentence` still a string? We don't know. It depends on the type of `x`. Maybe `x `used to be a string but during refactoring it is now a byte array. Or you think it's ASCII but in fact it's UTF8. Fun times had by all. 🎉

What about this one?


```python
filesize = "5000" # Size in bytes
```

Here, we express a file size as a string.
While this might work, it's frightening to work with.
For instance, simple calculations might lead to unexpected results:  

```python
file1 = "5000"
file2 = "3000"
total = file1 + file2
print(total) # prints '50003000'
```

We can *assume* that a file size is always a number.
To be even more precise, it must be a *positive, natural number*.
There can be no negative file size and our smallest unit is one byte
(on all but the most [obscure systems](https://en.wikipedia.org/wiki/4-bit)).
And since we're dealing with a discrete machine here, we know it can only be
a size for a file that the machine can handle.
If we could only express this intent in a concise way...
This is where a type system shine.

In Rust you could define a type `File` with a field `size`:

```
struct File {
  name: String,
  size: usize,
}
```

Notice that there is no more ambiguity, no arbitrariness.
You can't create an invalid file object:

```
// This will not work because `size` is a string.
let weird_file = File { name: 123, size: "hello" };
```

The type system will prevent invalid state. It will simply not *allow* you to
break your own rules. It will hold you accountable for your design choices.
Dare I say it: it becomes an extension of your brain.
After some time you start to rely on the type checker. "If it compiles, it runs"
is a powerful mantra.


Let's look at one more example. Consider the following Python snippet:

```python
def filter(files):
  matches = []
  for file in files:
    if file.status == 0:
      matches.append(file)
  return matches
```

What does `0` represent?
We can't say. We are lacking the context!

The story gets a little clearer once we define an `enum` type like this:

FOOTNOTE(The native enum type was introduced very late in the history of Python. It serves as a nice
example of how enhancing the type system can help improve readability)

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
    if file.status == FileStatus.OPEN:
      matches.append(file)
  return matches
```

In a larger codebase, `FileStatus.OPEN` is much easier to search for than `0`.

> Don't think of types as constraints, think of them as a way to express your
thoughts more precicely. A type system can guide you towards the most elegant
representation of your ideas.

For instance, is the *order* of returned files relevant?
If not, then you should consider using a `set` instead of a `list`.
Always choose the type that most precicely fits your requirements.
If there is none in the standard library, create your own from simpler types.


### Where type systems really shine

> When you combine different types, magic happens.

All pieces suddenly fall into place when you choose your types wisely. Out of nowhere, the compiler will start
checking your type decisions and if all your types work well together. It will point out flaws in your mental model.
It gives you a great amount of safety during refactoring.

For example, let's think about sorting things.
When I think of sorting, I first think about a list of numbers:

```python
sort([1,5,4,3,2]) -> [1,2,3,4,5]
```

Some things just doesn't make much sense, such as sorting a list with mixed
content like strings and int:

```python
sorted([1, "fish"])
```

In Python 2, this would result in `[1, 'fish']`.
Since Python 3 this throws an Exception now:

```python
TypeError: '<' not supported between instances of 'str' and 'int'
```

The problematic thing is, that this happens at runtime.
That's because of Python's dynamic typing.
We could have avoided that with a statically typed language.









But, of course, numbers are not the only thing we can sort.
We can sort food by calories, animals by height or books by number of pages.
What do all of these things have in common?
The objects have some kind of order.
We can compare two objects based on that (calories, height, pages).


XXXXXXXXXXXX


EXAMPLE: Sorting and PartialOrd



