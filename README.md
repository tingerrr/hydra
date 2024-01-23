# hydra
Hydra is a [typst] package allowing you to easily display the heading like elements anywhere in your
document. In short, it will show you the currently active element only when it is not visible.

Some of hydra's features rely on the size of the top-margin, if you use a different page size than
`a4` or a custom top margin for your pages, make sure to configure hydra, otherwise those checks may
not work.

## Example
```typst
#import "@preview/hydra:0.3.0": hydra

#set page(header: hydra() + line(length: 100%))
#set heading(numbering: "1.1")
#show heading.where(level: 1): it => pagebreak(weak: true) + it

= Introduction
#lorem(750)

= Content
== First Section
#lorem(500)
== Second Section
#lorem(250)
== Third Section
#lorem(500)

= Annex
#lorem(10)
```
![ex1]
![ex2]
![ex3]
![ex4]
![ex5]

## Documentation
For a more in-depth description of hydra's functionality and the reference read its [manual].

## Contribution
### Bug fixes
If you want to fix an issue please leave a comment there so others know. If you want to fix a bug
which doesn't have an issue yet, please create an issue first. Exceptions are typos or minor
improvements, just making the PR will be enough.

### Features
When adding features, make sure you add regression tests for this feature. See the testing section
below on testing. Make sure to document the feature, see the manual section on manual and examples
below.

### Testing
To ensure that your changes don't break exisiting code test it using the package's regression tests.
This is done automatically on pull requests, so you don't need not install [typst-test], but it's
nontheless recommended for faster iteration. In general, running `typst-test run` will be enough to
ensure your changes are correct.

### Manual and examples
The manual and example images are created from a quite frankly convoluted nushell script. If you
have, or don't mind installing, [nushell], [just] and [imagemagick], then you can simply run `just
gen` to generate a new manual and examples.

The examples inside the docs currently don't make it easy to simplify this without generating them
manually the whole time. Typst is missing a feature or plugin that allows embedding whole other
typst documents at the moment.

[ex1]: examples/example1.png
[ex2]: examples/example2.png
[ex3]: examples/example3.png
[ex4]: examples/example4.png
[ex5]: examples/example5.png
[manual]: docs/manual.pdf

[typst]: https://github.com/typst/typst
[typst-test]: https://github.com/tingerrr/typst-test
[just]: https://just.systems/
[nushell]: https://www.nushell.sh/
[imagemagick]: https://imagemagick.org/
