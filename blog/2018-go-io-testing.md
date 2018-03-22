extends: default.liquid

title:      "How to Avoid file I/O in Golang Unit Tests Without Mocking"
date:       22 Mar 2018 00:00:00 +0000
humandate:  22nd of March 2018
path:       2018/go-io-testing
---

At work today, I refactored some simple Go code to make it more testable.
The idea was to avoid file handling in unit tests without mocking or using temporary files by separating data input/output and data manipulation.

I was surprised that I couldn't find a simple explanation on sites like StackOverflow,
which is why I wrote down some notes myself so that others can refer to it in the future.

### Our example code

The initial version looked like this:

```go
package main

import (
	"bufio"
	"io/ioutil"
	"os"
)

func main() {
	analyze("test.txt")
}

func analyze(file string) error {
	handle, err := os.Open(file)

	if err != nil {
		return err
	}
	defer handle.Close()

	scanner := bufio.NewScanner(handle)
	for scanner.Scan() {
		// Do something with line
		_ = scanner.Text()
	}
	return nil
}
```

As you can see, we take a filename as input, and we open that file inside the `analyze` function to do something with its contents.

### Writing our first test for the code

A typical test harness for that code might look like this:

```go
package main

import "testing"

func Test_analyze(t *testing.T) {
	t.Run("Test something", func(t *testing.T) {
		if err := analyze("test.txt"); (err != nil) != false {
			t.Errorf("analyze() error = %v", err)
		}
	})
}
```

All fine and good?  

### Problems

This will work, but file I/O while running tests is not always the best idea.
For one, you could be running in a constrained environment, where you don't have access to the file.
We could use [temporary files](https://stackoverflow.com/a/20924657/270334) to avoid this.

But there might be problems with disk I/O, which makes for flaky tests and frustration.  
Another process could also modify the file during the test.
All these issues have nothing to do with your code.

Furthermore, it's not enough to just look at the test and see exactly what's going on. You also have to read the text file first.

A lot of people [suggest mocking](https://stackoverflow.com/a/37035375/270334) instead. 
There are quite a few powerful libraries like [spf13/afero](https://github.com/spf13/afero) for this purpose.
These packages will create temporary files in the background and clean up afterward.

In my opinion, mocking should be the last resort when it comes to testing. Before you mock, check that you use the right abstractions in your code.
Maybe implementing against an interface or using Dependency Injection helps decouple components?
More often than not, a clear separation of concerns is all you need.

### Refactoring to make testing easier

In my case above, we can easily avoid using mocks and temporary files by decoupling file I/O from the analysis.
We do so by refactoring our `analyze` function to call `doSomething`, which takes an [`io.Reader`](https://golang.org/pkg/io/#Reader).
(You could also use an array of strings for now.)

Our `main.go` now looks like this:

```go
package main

import (
	"bufio"
	"io"
	"os"
)

func main() {
	analyze("test.txt")
}

func analyze(file string) error {
	handle, err := os.Open(file)

	if err != nil {
		return err
	}
	defer handle.Close()
	return doSomething(handle)
}

func doSomething(handle io.Reader) error {
	scanner := bufio.NewScanner(handle)
	for scanner.Scan() {
		// Do something with line
		_ = scanner.Text()
	}
	return nil
}
```

Now we can test the actual analysis in isolation:

```go
package main

import (
	"strings"
	"testing"
)

func Test_analyze(t *testing.T) {
	t.Run("Test something", func(t *testing.T) {
		if err := doSomething(strings.NewReader("This is a test string")); (err != nil) != false {
			t.Errorf("analyze() error = %v", err)
		}
	})
}
```

We changed `analyze("test.txt")` to `doSomething(strings.NewReader("This is a test string"))`.

### Result

By slightly refactoring our code, we gained the following advantages:

* *Simple testability*: No mocks or temporary files.
* *Separation of concerns*: Each function does exactly one thing.
* *Easier code re-use*: The `doSomething()` function will work with any `io.Reader` and can be called from other places. We can even move it to its own library if we want.