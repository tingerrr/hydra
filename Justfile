set quiet
set shell := ['nu', '-c']

root := justfile_directory()

# list recipes
[private]
default:
	just --list

# generate example images
gen-examples:
	#! /usr/bin/env nu
	(typst compile
		--root {{ root }}
		examples/main.typ
		examples/example{n}.png)

	(ls examples
		| where name =~ '\.png$'
		| get name
		| each {|it| magick convert $it -crop 1191x200++0+0 $it}
		| ignore)

# generate doc examples
gen-doc-examples:
	#! /usr/bin/env nu
	ls docs/examples
		| where type == dir
		| get name
		| each {|it|
			cd $it
			rm --recursive --force out
			mkdir out
			[a b] | each {|it|
				(typst compile
					--root {{ root }}
					$"($it).typ"
					$"out/($it){n}.png")
			};
			let pages = (ls out | length) / 2;
			{ pages: $pages } | to toml | save out.toml
		}
		| ignore

# generate the manual
doc: gen-doc-examples
	#! /usr/bin/env nu
	(typst compile
		--root {{ root }}
		docs/manual.typ
		docs/manual.pdf)

# run the test suite
test filter='':
	typst-test run {{ filter }}
