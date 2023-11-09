# hydra
Hydra is a [typst] package allowing you to easily display the current section anywhere in your
document. By default, it will assume that it is used in the header of your document and display
the last heading if and only if it is numbered and the next heading is not the first on the current
page.

By default hdyra assumes that you use `a4` page size, see the FAQ if you use different page size or
margins.

## Example
```typst
#import "@preview/hydra:0.0.1": hydra
#set page(header: hydra())
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
![example1][example1]
![example2][example2]

## Non-default behavior
### Configuring filter and display
By default it will hydra will display `[#numbering #body]` of the heading and this reject unnumbered
ones. This filtering can be configured using `prev-filter` and `next-filter`, if those are changed
to include unnumbered headings `display` be changed too.
```typst
#set page(header: hydra(prev-filter: _ => true, display: h => h.body))
```

Keep in mind that `next-filter` is also responsible for checking that the next heading is on the
current page.

### In the footer
To use the hydra functon in the footer of your doc, pass `is-footer: true` and place a
`#metadata(()) <hydra>` somewhere in your header.

```typst
#set page(header: [#metadata(()) <hydra>], footer: hydra(is-footer: true))
```

Using it outside of footer or header should work as expected.

### Different heading levels or custom heading types
If you use a `figure`-based element for special 0-level chapters or you wish to only consider
specific levels of headings, pass the appropriate selector.

```typst
// only consider level 1
#set page(header: hydra(sel: heading.where(level: 1)))

// only consider level 1 - 3
#set page(header: hydra(sel: (heading, h => h.level <= 3)))

// consider also figures with this kind, must likely override all default functions other than
// resolve, or resolve directly, see source
#set page(header: hydra(sel: figure.where(kind: "chapter").or(heading), display: ...)
```

In short, `sel` can be a selector, or a selector and a filter function. When using anything other
than headings only, consider setting `display` too.

## FAQ
**Q:** Why does hydra display the previous heading if there is a heading at the top of my page?

**A:** If you use non `a4` page margins make sure to pass
`next-filter: default.next-filter.with(top-margin: ...)`. This margin must be known for the default
implementation. If it does but you are using `a4`, then you found a bug.

[example1]: example1.png
[example2]: example2.png
[typst]: https://github.com/typst/typst
