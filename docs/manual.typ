#import "@preview/tidy:0.1.0"

#import "template.typ": project

#let package = toml("/typst.toml").package

#show: project.with(
  package: package,
  date: datetime.today().display(),
  abstract: [
    A package for querying and displaying heading-like elements.
  ]
)

#let load-examples(example) = {
  let path = "/docs/examples/" + example
  // NOTE: this breaks for docs with more than 10 pages, but at this point the example is too large
  //       anyway
  let example = (v, i) => image(path + "/out/" + v + str(i) + ".png")
  let r = range(1, toml(path + "/out.toml").pages + 1)

  (
    a: r.map(i => example("a", i)),
    b: r.map(i => example("b", i)),
  )
}

#let show-examples(examples, width: 50%) = block(
  width: width,
  fill: gray,
  inset: 0.5em,
  grid(columns: (1fr, 1fr), gutter: 0.5em, align(center + horizon)[Binding], ..examples),
)

#let issue(num) = link(package.repository + "/issues/" + str(num))[hydra\##num]

#let raw-bg = gray.lighten(50%)
#let bbox = box.with(inset: (x: 0.25em), outset: (y: 0.25em), radius: 0.25em)

#set heading(numbering: (..args) => if args.pos().len() == 1 {
  numbering("I", ..args)
} else {
  numbering("1.", ..args.pos().slice(1))
})

#show heading.where(level: 1): it => pagebreak(weak: true) + it

#show raw.where(block: true): it => {
  set block(fill: raw-bg, width: 100%, inset: 0.5em, radius: 0.5em)
  show "{{VERSION}}": package.version
  it
}
#show raw.where(block: false): bbox.with(fill: raw-bg)

#outline(indent: auto)

= Introduction
`hydra` is a package primarily for displaying the active section or chapter in the header of your
document.

== Terminology & Semantics
#[
  The following terms are often used in the following sections to explain the behavior and reasoning
  of `hydra`:

  #show terms: its => grid(
    row-gutter: 1em,
    column-gutter: 0.4em,
    columns: (auto, auto),
    ..its.children.map(it => (
      align(right)[*#it.term*],
      align(left, par(justify: true, it.description)),
    )).flatten(),
  )

  / primary: The element which is primarily looked for and meant to be displayed.
  / ancestor: An element which is the immediate or transitive ancestor to the primary element.
    A level 3 heading is ancestor to both level 2 (directly) and level 1 headings (transitively).
  / scope: The scope of a primary element refers to the section of a document which is between the
    closest ancestors.
  / active: The active element refers to whatever element is considered for display. While this is usually the previous primary element, it may sometimes be the next primary element.
]

The search for a primary element is always bounded to it's scope, such that, for the following
simplified document, the output of `hydra` does not revert to Section 1.1.

```typst
= Chapter 1
== Section 1.1

= Chapter 2
=== Subsection 2.1.1
#hydra(2)
```

For this the ancestors of an element must be known. For headings this is simple: \
#align(center, (
  `none`,
  `level: 1`,
  `level: 2`,
  `level: 3`,
  `...`,
).join([ #sym.arrow ]))

If `hydra` is used to query for level 2 headings it will only do so within the bounds of the closest
level 3 headings. In principle, elements other than headings can be used (see @custom), as long as
their semantic relationships are established.

= Features
== Sane Defaults
If `hydra` is called with no arguments it will not assume anything about your document other than
the typst defaults. I.e. that the paper size is `a4`, that the margins and page sizes are not set
and that you intend to simply show the last active heading without showing it where it's obvious.

== Custom Elements <custom>
Because some documents may use custom elements of some kind to display chapters or section like
elements, `hydra` allows defining its own selectors for tight control over how elements are
semantically related.

Given a custom element like so:
```typst
#let chapter = figure.with(kind: "chapter", supplement: [Chapter])
// ... show rules and additional setup

#chapter[Introduction]
#chapter[Main]
= Section 1.1
== Subsection 1.1.1
= Section 1.2
#chapter[Annex]
```

A user my want to query for the current chapter and section respectively:
```typst
#import "@preview/hydra:{{VERSION}}": hydra, selectors
#import selectors: custom

#let chap = figure.where(kind: "chapter")
#let sect = custom(heading.where(level: 1), ancestor: chap)

#set page(header: locate(loc => if calc.odd(loc.page()) {
  algin(left, hydra(chap))
} else {
  algin(right, hydra(sect))
}))
```

The usage of `custom` allows specifying an element's ancestors, to ensure the scope is corectly
defined.

#pagebreak()
== Redundancy Checks
Generally `hydra` is used for heading like elements, i.e. elements which semantically describe a
section of a document. Whenever `hydra` is used in a place where its output would be redundant, it
will not show any output by default. The following sections explain the those checks more closely
and will generally assume that hydra is looking for headings.

=== Starting Page
Given a page which starts with a primary element, it will not show anything. If `skip-starting` is
set to `false`, it will fallback to the next element, in this case the heaiding at the top of the
page.

#let skip = load-examples("skip")
#figure(
  grid(columns: 2, show-examples(skip.a, width: 95%), show-examples(skip.b, width: 95%)),
  caption: [
    An example document showing `skip-starting: true` (left) and `skip-starting: false` (right).
  ],
)

For more complex selectors this will not correctly work if the first element on this page is an
ancestor. See #issue(8).

#pagebreak()
=== Book Mode
Given an odd page, if `book` is set to `true`, then if the previous primary element is still
visible on the previous page it is also skipped.

#let book = load-examples("book")
#figure(
  grid(columns: 2, show-examples(book.a, width: 95%), show-examples(book.b, width: 95%)),
  caption: [An example document showing `book: false` (left) and `book: true` (right).],
)

#pagebreak()
== Optional Function Coloring
Hydra requires a context to work, more specifically it needs to know it's own location relative to
the elements it queries for. To avoid the need for a user having to use hdyra inside `locate` all
the time `hydra` will do it by itself. But if it always did this, it would not allow the user to
actually check the return value. The following will not work:

```typst
#import "@preview/hydra:{{VERSION}}": hydra
#set page(header: {
  let chap = hydra(1)
  if chap != none [
    Chapter #chap
  ]
})
```

Because `hydra` needs a location it'll internally call `locate`, making the return value a `locate`
element. The fix is quite simple, if a location is provided the return is not wrapped and the
callback result is returned as is.

```typst
#import "@preview/hydra:{{VERSION}}": hydra
#set page(header: locate(loc => {
  let chap = hydra(1, loc: loc)
  if chap != none [
    Chapter #chap
  ]
}))
```

This means that passing a location in contexts where one is already available will generally avoid
uncessary function coloring. This allows for more complex queries in casese where both a chapter
and section are shown for example.

== Anchoring
To use `hydra` outside of the header, an `anchor` must be placed to get the correct active elements.
`hydra` will always use the last anchor it finds to search, it doesn't have ot be inside the header,
but should generally be, otherwise the behavior may be unexpected.

```typst
#import "@preview/hydra:{{VERSION}}": hydra, anchor
#set page(header: anchor(), footer: hydra())
```

= Reference
#let stable(is) = if is {
  show raw: it => bbox(fill: green.lighten(50%), it.text)
  `stable`
} else {
  show raw: it => bbox(fill: yellow.lighten(50%), it.text)
  `unstable`
}

== Stability
The following stability guarantees are made, this package tries to adhere to semantic versioning.

#table(stroke: none, columns: 2, gutter: 0.25em,
  stable(false), [API may change with any version bump.],
  stable(true), [
    API will not change without a major version bump or a minor version bump pre `1.0.0`, if such a
    change occures it is a bug and unintended.
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
  primary: (prev: content | none, next: content | none)
  ancestor: (prev: content | none, next: content | none)
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
  book: bool,
  top-margin: length,
  anchor: label | none,
  loc: location,
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
    Contians functions used for creating custom selectors.
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
