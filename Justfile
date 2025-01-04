set shell := ['nu', '-c']

export TYPST_ROOT := justfile_directory()

# list recipes
[private]
default:
	just --list

# generate example images
gen-examples:
	rm --recursive --force pages examples/pages
	mkdir examples/pages
	typst compile --ppi 300 examples/pages.typ examples/pages/{n}.png
	typst compile examples/main.typ examples/example.png
	rm --recursive --force pages examples/pages
	oxipng --opt max examples/example.png

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
			let pages = (ls out | length) / 2 | into int;
			{ pages: $pages } | to toml | save -f out.toml
		}
		| ignore

	oxipng --recursive --opt max doc

# generate the manual
doc: gen-doc-examples
	typst compile doc/manual.typ doc/manual.pdf

# run the test suite
test *args:
	typst-test run {{ args }}

# update the test suite
update *args:
	typst-test update {{ args }}

# run the ci test suite
ci:
	# run one single test first to avoid a race condition on package downloads
	typst-test run regressions/scoped-search
	typst-test run
