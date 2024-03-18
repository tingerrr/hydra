set shell := ['nu', '-c']

export TYPST_ROOT := justfile_directory()

# list recipes
[private]
default:
	just --list

# generate example images
gen-examples:
	typst compile --ppi 300 examples/pages.typ examples/page{n}.png
	typst compile examples/main.typ examples/example.png
	oxipng --recursive --opt max examples

# generate doc examples
gen-doc-examples:
	#! /usr/bin/env nu
	ls doc/examples
		| where type == dir
		| get name
		| each {|it|
			cd $it
			rm --recursive --force out
			mkdir out
			[a b] | each {|it|
				(typst compile
					$"($it).typ"
					$"out/($it){n}.png")
			};
			let pages = (ls out | length) / 2;
			{ pages: $pages } | to toml | save out.toml
		}
		| ignore

	oxipng --recursive --opt max doc

# generate the manual
doc: gen-doc-examples
	typst compile doc/manual.typ doc/manual.pdf

# copy the files relevant for the package repo
publish output:
	alabaster package {{ output }}

# run the test suite
test filter='':
	typst-test run {{ filter }}
