docs := 'docs'
manual := docs / 'manual'
examples := docs / 'examples'

assets := 'assets'
fonts := assets / 'fonts'
images := assets / 'images'
thumbnail := images / 'thumbnail'

export TYPST_ROOT := justfile_directory()
export TYPST_FONT_PATHS := fonts

# list recipes
[private]
default:
	@just --list --unsorted

# run tytanic with the correct assets
[positional-arguments]
tt *args:
	@tt "$@"

# run the full test suite
test:
	tt run --no-fail-fast --expression 'all()'

# update all persistent assets
update: update-manual update-thumbnail

# generate all non-persistent assets
generate: generate-manual generate-thumbnail

# clean all output directories
clean:
	rm --recursive --force {{ manual / 'out' }}
	rm --recursive --force {{ examples / 'book' / 'out' }}
	rm --recursive --force {{ examples / 'skip' / 'out' }}
	rm --recursive --force {{ thumbnail / 'out' }}
	tt util clean

# run the ci checks locally
ci: generate test

# update the package thumbnail
update-thumbnail: generate-thumbnail
	oxipng --opt max {{ thumbnail / 'out' / 'thumbnail.png' }}
	cp {{ thumbnail / 'out' / 'thumbnail.png' }} {{ images / 'thumbnail.png' }}

# generate the package thumbnail
generate-thumbnail: (clear-directory (thumbnail / 'out'))
	typst compile \
		--ppi 300 \
		{{ thumbnail / 'pages.typ' }} \
		{{ thumbnail / 'out' / '{n}.png' }}
	typst compile \
		{{ thumbnail / 'thumbnail.typ' }} \
		{{ thumbnail / 'out' / 'thumbnail.png' }}

# generate all docs examples
generate-examples: (generate-example 'book') (generate-example 'skip')

# generate a single docs example
generate-example example: (clear-directory (examples / example / 'out'))
	typst compile \
		--ppi 300 \
		{{ examples / example / 'a.typ' }} \
		{{ examples / example / 'out' / 'a{n}.png' }}
	typst compile \
		--ppi 300 \
		{{ examples / example / 'b.typ' }} \
		{{ examples / example / 'out' / 'b{n}.png' }}

# generate a new manual and update it
update-manual: generate-manual
	cp {{ manual / 'out' / 'manual.pdf' }} {{ assets / 'manual.pdf' }}

# generate the manual
generate-manual: (clear-directory (manual / 'out')) generate-examples
	typst compile \
		{{ manual / 'manual.typ' }} \
		{{ manual / 'out' / 'manual.pdf' }}

# watch the manual
watch-manual: (clear-directory (manual / 'out')) generate-examples
	typst watch \
		{{ manual / 'manual.typ' }} \
		{{ manual / 'out' / 'manual.pdf' }}

[private]
clear-directory dir:
	rm --recursive --force {{ dir }}
	mkdir {{ dir }}
