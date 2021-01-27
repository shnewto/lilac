default: clean build

run: clean build
	./_build/default/bin/lilacbin.exe $(args)

clean:
	dune clean

build:
	dune build

test: clean build
	dune runtest

.PHONY: clean
