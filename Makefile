default: clean build

run: clean build
	./_build/default/bin/bin.exe $(args)

clean:
	dune clean

build:
	dune build

test: clean build
	dune runtest

.PHONY: clean
