_doc := 'doc'
_assets := 'assets'
_examples := _assets / 'examples'
_showcase := _assets / 'showcase'

export TYPST_ROOT := justfile_directory()
export TYPST_FONT_PATHS := justfile_directory() / 'assets' / 'fonts'

# list recipes
[private]
default:
	@just --list --unsorted

# run the test suite
[positional-arguments]
test *args:
	tt run "$@"

# update the test suite
[positional-arguments]
update *args:
	tt update "$@"

# clean all output directories
clean:
	rm --recursive --force {{ _doc / 'out' }}
	rm --recursive --force {{ _examples / 'book' / 'out' }}
	rm --recursive --force {{ _examples / 'skip' / 'out' }}
	rm --recursive --force {{ _showcase / 'out' }}
	tt util clean

# run the ci checks locally
ci: generate-doc generate-showcase (test '--no-fail-fast')

# update the showcase image
update-showcase: generate-showcase
	oxipng --opt max {{ _showcase / 'out' / 'showcase.png' }}
	cp {{ _showcase / 'out' / 'showcase.png' }} {{ _assets / 'showcase.png' }}

# generate the showcase image
generate-showcase: (clear-directory (_showcase / 'out'))
	typst compile \
		--ppi 300 \
		{{ _showcase / 'pages.typ' }} \
		{{ _showcase / 'out' / '{n}.png' }}
	typst compile \
		{{ _showcase / 'showcase.typ' }} \
		{{ _showcase / 'out' / 'showcase.png' }}

# generate all doc examples
generate-examples: (generate-example 'book') (generate-example 'skip')

# generate a single doc example
generate-example example: (clear-directory (_examples / example / 'out'))
	typst compile \
		--ppi 300 \
		{{ _examples / example / 'a.typ' }} \
		{{ _examples / example / 'out' / 'a{n}.png' }}
	typst compile \
		--ppi 300 \
		{{ _examples / example / 'b.typ' }} \
		{{ _examples / example / 'out' / 'b{n}.png' }}

# generate a new manual and update it
update-doc: generate-doc
	cp {{ _doc / 'out' / 'manual.pdf' }} {{ _assets / 'manual.pdf' }}

# generate the manual
generate-doc: (clear-directory (_doc / 'out')) generate-examples
	typst compile \
		{{ _doc / 'manual.typ' }} \
		{{ _doc / 'out' / 'manual.pdf' }}

# watch the manual
watch-doc: (clear-directory (_doc / 'out')) generate-examples
	typst watch \
		{{ _doc / 'manual.typ' }} \
		{{ _doc / 'out' / 'manual.pdf' }}

[private]
clear-directory dir:
	rm --recursive --force {{ dir }}
	mkdir {{ dir }}
