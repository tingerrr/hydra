#import "/doc/util.typ": load-examples, show-examples, issue

== Contextual
Hydra will take contextual information into account to provide good defaults, such as inferring the
reading direction and binding from the page and text styles to offer correct handling of books as
seen in @book-mode.

== Custom Elements <custom>
Because some documents may use custom elements of some kind to display chapters or section like
elements, hydra allows defining its own selectors for tight control over how elements are
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

#set page(header: context if calc.odd(here().page()) {
  align(left, hydra(chap))
} else {
  align(right, hydra(sect))
})
```

The usage of `custom` allows specifying an element's ancestors, to ensure the scope is correctly
defined. The selectors module also contains some useful default selectors.

#pagebreak()
== Redundancy Checks
Generally hydra is used for heading like elements, i.e. elements which semantically describe a
section of a document. Whenever hydra is used in a place where its output would be redundant, it
will not show any output by default. The following sections explain those checks more closely and
will generally assume that hydra is looking for headings for simplicity.

=== Starting Page <starting-page>
Given a page which starts with a primary element, it will not show anything. If `skip-starting` is
set to `false`, it will fallback to the next element, in this case the heading at the top of the
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
=== Book Mode <book-mode>
Given a leading page, if `book` is set to `true`, then if the previous primary element is still
visible on the previous (trailing) page it is also skipped.

#let book = load-examples("book")
#figure(
  grid(columns: 2, show-examples(book.a, width: 95%), show-examples(book.b, width: 95%)),
  caption: [An example document showing `book: false` (left) and `book: true` (right).],
)

This may produce unexpected results with hydra is used outside the header and the text direction
where it is used is different to where it's anchor (see @anchor) is placed.

== Anchoring <anchor>
To use hydra outside of the header, an anchor must be placed to get the correct active elements.
hydra will always use the last anchor it finds to search, it doesn't have to be inside the header,
but should generally be, otherwise the behavior may be unexpected.

```typst
#import "@preview/hydra:{{VERSION}}": hydra, anchor
#set page(header: anchor(), footer: context hydra())
```
