#import "@preview/tidy:0.2.0"
#import "/doc/util.typ": bbox

#let stable(is-stable) = if is-stable {
  bbox(fill: green.lighten(50%), `stable`)
} else {
  bbox(fill: yellow.lighten(50%), `unstable`)
}

== Stability
The following stability guarantees are made, this package tries to adhere to semantic versioning.

#table(columns: 2, gutter: 0.25em, align: (right, left),
  stable(false), [API may change with any version bump.],
  stable(true), [
    API will not change without a major version bump or a minor version bump before `1.0.0`, if such
    a change occures it is a bug and unintended.
  ],
)

== Custom Types
#set heading(outlined: false)
The following custom types are used to pass around information easily:

=== `sanitized-selector` #stable(true)
Defines a selector for an ancestor or primary element.
```typc
(
  target: queryable,
  filter: ((context, candidates) => bool) | none,
)
```

=== `hydra-selector` #stable(true)
Defines a pair of primary and ancestor element selectors.

```typc
(
  primary: sanitized-selector,
  ancestors: sanitized-selector | none,
)
```

=== `candidates` #stable(true)
Defines the candidates that have been found in a specific context.

```typc
(
  primary: (prev: content | none, next: content | none, last: content | none),
  ancestor: (prev: content | none, next: content | none),
)
```

=== `context` #stable(false)
Defines the options passed to hydra nad resolved contextual information needed for querying and
displaying.

```typc
(
  prev-filter: (context, candidates) => bool,
  next-filter: (context, candidates) => bool,
  display: (context, content) => content,
  skip-starting: bool,
  use-last: bool,
  book: bool,
  anchor: label | none,
  anchor-loc: location,
  primary: sanitized-selector,
  ancestors: sanitized-selector,
)
```

#pagebreak()
#set heading(numbering: none)

#let mods = (
  (`hydra`, "/src/lib.typ", true, [
    The package entry point. All functions validate their inputs and panic using error messages
    directed at the end user.
  ]),
  (`core`, "/src/core.typ", false, [
    The core logic module. Some functions may return results with error messages that can be used to
    panic or recover from instead of panicking themselves.
  ]),
  (`selectors`, "/src/selectors.typ", true, [
    Contains functions used for creating custom selectors.
  ]),
  (`util`, "/src/util.typ", false, [
    Utlity functions and values.
  ]),
  (`util/core`, "/src/util/core.typ", false, [
    Utlity functions.
  ]),
  (`util/assert`, "/src/util/assert.typ", false, [
    Assertions used for input and state validation.
  ]),
)

#let render-module(title, path, is-stable, description, style: tidy.styles.minimal) = [
  == #title #stable(is-stable)

  #description
  #tidy.show-module(tidy.parse-module(read(path)), style: style)
]

#mods.map(x => render-module(..x)).join(pagebreak(weak: true))
