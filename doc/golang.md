# Debugging

- debug a specific test-case
```sh
dlv test --build-flags='path/to/module' -- -test.run ^TestFunctionName$
```

- run a specific test-case
```
go test -run TestFunctionName
```

