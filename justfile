# use nushell
self := justfile_directory()
set shell := ['nu', '-c']

# list recipes
[private]
default:
	@just --list

# generate example images
gen:
	typst compile \
		--root {{ self }} \
		examples/main.typ \
		examples/example{n}.png

	ls examples/ \
		| where name =~ '\.png$' \
		| get name \
		| each {|it| magick convert $it -crop 1191x200++0+0 $it}

# run a minimal test harness
test filter='':
	@{{ self }}/tests/run.nu '{{ filter }}'
