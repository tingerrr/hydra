# use nushell
self := justfile_directory()
set shell := ['nu', '-c']

# list recipes
[private]
default:
	@just --list

# generate example images
gen-examples:
	typst compile \
		--root {{ self }} \
		examples/main.typ \
		examples/example{n}.png

	ls examples \
		| where name =~ '\.png$' \
		| get name \
		| each {|it| magick convert $it -crop 1191x200++0+0 $it} \
		| ignore

# generate docs
gen-docs:
	ls docs/examples \
		| where type == dir \
		| get name \
		| each {|it| \
			cd $it; \
			rm --recursive --force out; \
			mkdir out; \
			[a b] | each {|it| \
				typst compile \
					--root {{ self }} \
					$"($it).typ" \
					$"out/($it){n}.png" \
			}; \
			let pages = (ls out | length) / 2; \
			{ pages: $pages } | to toml | save out.toml \
		} \
		| ignore

	typst compile \
		--root {{ self }} \
		docs/manual.typ \
		docs/manual.pdf

# watch docs
watch-docs:
	typst watch \
		--root {{ self }} \
		docs/manual.typ \
		docs/manual.pdf

# generate examples and docs
gen: gen-examples gen-docs

# run a minimal test harness
test filter='':
	@{{ self }}/tests/run.nu '{{ filter }}'
