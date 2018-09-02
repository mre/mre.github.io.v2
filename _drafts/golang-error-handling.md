Go vs Rust: Simple error handling

```go
foo, err := FailingMethod()
if err != nil {
    log.Fatal("failed")
}

bar, err := FailingMethod()
if err != nil {
    log.Fatal("failed")
}
```

Refactoring causes leftover/useless error handling code:

```go
foo, err := FailingMethod()
if err != nil {
    log.Fatal("boom")
}

bar := HarmlessMethod()
if err != nil {
    log.Fatal("unnecessary check")
}
```