# Go
## Modules
```sh
go mod init <module>
go mod tidy                     # add missing, remove unused deps
go get <pkg>@latest
```

## Build & run
```sh
go run .
go build -o bin/app .
GOOS=linux GOARCH=amd64 go build -o app .   # cross-compile
```

## Test
```sh
go test ./...
go test -run TestFoo ./...
go test -v -cover ./...
```

## Tools
```sh
go vet ./...                    # static analysis
gofmt -w .                      # format code
go doc <pkg> <symbol>
dlv debug                       # delve debugger
```
