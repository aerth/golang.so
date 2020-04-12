# Build a C shared library (.so, .dll)
# Copyright 2020 aerth  <aerth@riseup.net>
# See LICENSE file
# https://github.com/aerth/golang.so

# set name of .so file
outdir := ./out/
main_so := ${outdir}golang.so
windows_so := ${outdir}golang32.dll
windows_so64 := ${outdir}golang64.dll

default: clean all test
all: ${main_so} ${windows_so} ${windows_so64}
${main_so}: *.go
	  go build -o $@ --buildmode c-shared -ldflags "-X main.gitcommit=`git rev-parse --short=8 HEAD` -X main.built=`date -u '+%Y-%m-%d_%I:%M:%S%p'`"
${windows_so}: *.go
	  env CGO_ENABLED=1 CC=i686-w64-mingw32-gcc GOOS=windows GOARCH=386 go build -o $@ --buildmode c-shared -ldflags "-X main.gitcommit=`git rev-parse --short=8 HEAD` -X main.built=`date -u '+%Y-%m-%d_%I:%M:%S%p'`"
${windows_so64}: *.go
	  env CGO_ENABLED=1 CC=x86_64-w64-mingw32-gcc GOOS=windows GOARCH=amd64 go build -o $@ --buildmode c-shared -ldflags "-X main.gitcommit=`git rev-parse --short=8 HEAD` -X main.built=`date -u '+%Y-%m-%d_%I:%M:%S%p'`"
clean:
	rm -vf ${main_so} ${windows_so} ${windows_so64}
test:
	@echo
	@echo Test Suite
	@echo
	@echo Symbols:
	@bash scripts/dump_symbols.bash ${main_so}
	@echo
	@echo "Test.py (ctypes)"
	@echo
	@python3 scripts/test.py ${main_so}
	@echo
	@echo "Test.py (cffi)"
	@echo
	@python3 scripts/test-ffi.py ${main_so}

