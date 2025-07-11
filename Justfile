docs := 'docs'
manual := docs / 'manual'
examples := docs / 'examples'

assets := 'assets'
fonts := assets / 'fonts'
images := assets / 'images'
thumbnail := images / 'thumbnail'

export TYPST_ROOT := justfile_directory()
export TYPST_FONT_PATHS := fonts

prompt := BOLD + GREEN + ">>>" + NORMAL

alias t := test
alias c := check
alias f := format
alias fmt := format
alias d := doc

# list recipes
[private]
default:
	@just --list --unsorted

# run all tests
test: && test-unit
	@echo "{{prompt}} Running all tests"

# run the Tytanic unit test suite
test-unit:
	@echo "{{prompt}} Testing Tytanic suite (with max-delta: 1)"
	@tt run --no-fail-fast --max-delta 1 --expression 'all()'

# run all checks
check: && check-format check-doc
	@echo "{{prompt}} Running all checks"

# check the formatting
check-format:
	@echo "{{prompt}} Checking Typst files for formatting"
	@typstyle --diff {{ TYPST_ROOT }}

# check the documentation assets generation
check-doc: && doc-generate
	@echo "{{prompt}} Checking documentation assets generation for errors"

# format all Typst files
format:
	@echo "{{prompt}} Formatting Typst files in place"
	@typstyle --inplace {{ TYPST_ROOT }}

# generate the docs and thumbnail
doc: doc-generate

# update persistent documentation assets
doc-update: && update-manual update-thumbnail
	@echo "{{prompt}} Updating tracked manual and thumbnail"

# generate non-persistent documentation assets
doc-generate: && generate-manual generate-thumbnail
	@echo "{{prompt}} Generating local manual and thumbnail"

# clean all output directories
clean:
	@echo "{{prompt}} Removing temporary directories"
	@rm --recursive --force {{ manual / 'out' }}
	@rm --recursive --force {{ examples / 'book' / 'out' }}
	@rm --recursive --force {{ examples / 'skip' / 'out' }}
	@rm --recursive --force {{ thumbnail / 'out' }}
	@tt util clean

# run Tytanic with the correct environment
[positional-arguments]
tt *args:
	@tt "$@"

# run the ci checks locally
ci: test check

# update the package thumbnail
[private]
update-thumbnail: generate-thumbnail
	@echo "{{prompt}} Updating tracked thumbnail in {{ assets / 'thumbnail.png' }}"
	@oxipng --opt max {{ thumbnail / 'out' / 'thumbnail.png' }}
	@cp {{ thumbnail / 'out' / 'thumbnail.png' }} {{ images / 'thumbnail.png' }}

# generate the package thumbnail
[private]
generate-thumbnail: (clear-directory (thumbnail / 'out'))
	@typst compile \
		--ppi 300 \
		{{ thumbnail / 'pages.typ' }} \
		{{ thumbnail / 'out' / '{n}.png' }}
	@typst compile \
		{{ thumbnail / 'thumbnail.typ' }} \
		{{ thumbnail / 'out' / 'thumbnail.png' }}

# generate all docs examples
[private]
generate-examples: (generate-example 'book') (generate-example 'skip')

# generate a single docs example
[private]
generate-example example: (clear-directory (examples / example / 'out'))
	@typst compile \
		--ppi 300 \
		{{ examples / example / 'a.typ' }} \
		{{ examples / example / 'out' / 'a{n}.png' }}
	@typst compile \
		--ppi 300 \
		{{ examples / example / 'b.typ' }} \
		{{ examples / example / 'out' / 'b{n}.png' }}

# generate a new manual and update it
[private]
update-manual: generate-manual
	@echo "{{prompt}} Updating tracked manual in {{ assets / 'manual.pdf' }}"
	@cp {{ manual / 'out' / 'manual.pdf' }} {{ assets / 'manual.pdf' }}

# generate the manual
[private]
generate-manual: (clear-directory (manual / 'out')) generate-examples
	@typst compile \
		{{ manual / 'manual.typ' }} \
		{{ manual / 'out' / 'manual.pdf' }}

# watch the manual after generating its dependencies once
[private]
watch-manual: (clear-directory (manual / 'out')) generate-examples
	@typst watch \
		{{ manual / 'manual.typ' }} \
		{{ manual / 'out' / 'manual.pdf' }}

[private]
clear-directory dir:
	@rm --recursive --force {{ dir }}
	@mkdir {{ dir }}
