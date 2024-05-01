#import "/doc/util.typ": bbox, mantys
#import mantys: *

#let stable(is) = if is {
  bbox(fill: green.lighten(50%), `stable`)
} else {
  bbox(fill: yellow.lighten(50%), `unstable`)
}

= Stability
The following stability guarantees are made, this package tries to adhere to semantic versioning.

#table(columns: 2, gutter: 0.25em, align: (right, left), stroke: none,
  stable(false), table.vline(), [API may change with any version bump.],
  stable(true), [
    API will not change without a major version bump or a minor version bump before `1.0.0`, if such
    a change occurs it is a bug and unintended.
  ],
)

#let ref-heading(is-stable, body, label: none) = {
  [#heading(depth: 2, body) #label]
  place(
    right,
    dy: -2.4em,
    stable(is-stable),
  )
}

#let type-def(is-stable, color: auto, name) = {
  let name = name.text
  let l = label("type-" + name)
  ref-heading(is-stable, label: l)[#name]
  let args = if color != auto {
    (color: color)
  } else {
    ()
  }
  add-type(name, target: l, ..args)
}

#let lime = color.hsv(80deg, 30%, 100%)

= Custom Types
The following type definitions are used to simplify the documentation. The type definitions follow  a simple grammar similar to Typescript types.

#type-def(true)[queryable]
Any type which can be used in `query`, `function` refers to the subset of element functions which are locatable.

#codesnippet[
  ```typc
  let queryable = label | function | selector
  ```
]

#type-def(true, color: lime)[hydra-selector]
Defines a selector for an ancestor or primary element.

#codesnippet[
  ```typc
  let hydra-selector = (
    target: queryable,
    filter: ((hydra-context, candidates) => bool) | none,
  )
  ```
]

#type-def(true, color: lime)[full-selector]
Defines a pair of primary and ancestor element selectors.

#codesnippet[
  ```typc
  let full-selector = (
    primary: hydra-selector,
    ancestors: hydra-selector | none,
  )
  ```
]

#type-def(true, color: lime)[candidates]
Defines the candidates that have been found in a specific context.

#codesnippet[
  ```typc
  let candidates = (
    primary: (prev: content | none, next: content | none, last: content | none),
    ancestor: (prev: content | none, next: content | none),
  )
  ```
]

#type-def(false, color: lime)[hydra-context]
Defines the options passed to HYDRA and resolved contextual information needed for querying and
displaying.

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

#let mods = (
  ("hydra", "/src/lib.typ", true, [
    The package entry point. All functions validate their inputs and panic using error messages
    directed at the end user.
  ]),
  ("core", "/src/core.typ", false, [
    The core logic module. Some functions may return results with error messages that can be used to
    panic or recover from instead of panicking themselves.
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
  #ref-heading(is-stable, name)

  #description
  #tidy-module(read(path), name: name)
]

= Modules
#mods.map(x => render-module(..x)).join(pagebreak(weak: true))
