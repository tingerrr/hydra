#import "/docs/manual/util.typ": bbox, mantys
#import mantys: *

#let lime = color.hsv(80deg, 30%, 100%)

= Reference <sec:api>
== Custom Types
The following type definitions are used to simplify the documentation.
It's mostly pseudo code at the moment, `a | b` refers to a type of either `a` or `b`, i.e. a type union.
Other than that it is very similar to Typst itself, using type hints in place of values.
Most of these types are fairly unimportant for the actual end user the most important ones are:
- @type:hydra-selector: used as an alternative target to @cmd:hydra.sel
- @type:hydra-context: given to almost any internal function as well as various callback arguments on @cmd:hydra
- @type:candidates: given to @cmd:hydra.prev-filter and @cmd:hydra.next-filter

Internal functions do not validate these types, therefore incorrect usage may break on any patch version even if it previously worked out of chance, conformance to these schemas should always result in a working API of HYDRA.

#custom-type("queryable", color: lime)
#codesnippet[
  ```typc
  let queryable = label | function | selector
  ```
]

Any type which can be used in `query`, `function` refers to the subset of element functions which are locatable.

Defines a selector for an ancestor or primary element.

#custom-type("hydra-selector", color: lime)
#codesnippet[
  ```typc
  let hydra-selector = (
    target: queryable,
    filter: ((hydra-context, candidates) => bool) | none,
  )
  ```
]

Defines a pair of primary and ancestor element selectors.

#custom-type("full-selector", color: lime)
#codesnippet[
  ```typc
  let full-selector = (
    primary: hydra-selector,
    ancestors: hydra-selector | none,
  )
  ```
]

Defines the candidates that have been found in a specific context.

#custom-type("candidates", color: lime)
#codesnippet[
  ```typc
  let candidates = (
    primary: (prev: content | none, next: content | none, last: content | none),
    ancestor: (prev: content | none, next: content | none),
  )
  ```
]

Defines the options passed to @cmd:hydra and resolved contextual information needed for querying and displaying.

#custom-type("hydra-context", color: lime)
#codesnippet[
  ```typc
  let hydra-context = (
    prev-filter: (hydra-context, candidates) => bool,
    next-filter: (hydra-context, candidates) => bool,
    display: (hydra-context, content) => content,
    skip-starting: bool,
    use-last: bool,
    book: bool,
    anchor: label | none,
    anchor-loc: location,
    primary: hydra-selector,
    ancestors: hydra-selector,
  )
  ```
]

#pagebreak()

// @typstyle off
#let mods = (
  ("hydra", "/src/lib.typ", true, [
    The package entry point.
    All functions validate their inputs and panic using error messages directed at the end user.
  ]),
  ("core", "/src/core.typ", false, [
    The core logic module.
    Some functions may return results with error messages that can be used to panic or recover from instead of panicking themselves.
  ]),
  ("selectors", "/src/selectors.typ", true, [
    Contains functions used for creating custom selectors.
  ]),
  ("util", "/src/util.typ", false, [
    Utlity functions and values.
  ]),
  ("util/core", "/src/util/core.typ", false, [
    Utlity functions.
  ]),
  ("util/assert", "/src/util/assert.typ", false, [
    Assertions used for input and state validation.
  ]),
)

#let render-module(name, path, is-stable, description) = [
  #heading(depth: 3, name) #label("sec:mod:" + name)
  #place(right, dy: -2.4em, if is-stable {
    bbox(fill: green.lighten(50%), `stable`)
  } else {
    bbox(fill: yellow.lighten(50%), `unstable`)
  })

  #import "/docs/manual/util.typ": mantys
  #description
  #tidy-module(name, read(path), scope: (mantys: mantys))
]

== Modules
#mods.map(x => render-module(..x)).join(pagebreak(weak: true))
