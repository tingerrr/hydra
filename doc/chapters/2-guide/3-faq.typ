#import "/doc/util.typ": issues, issue

The following questions and answers largely use the simple heading use case, but may apply to any custom elements and selectors.

#let qna(q, a) = grid(
  columns: 2,
  row-gutter: 1em,
  inset: (x: 0.5em),
  [*Q*], strong(q),
  [*A*], grid.vline(start: 1), a,
)

#qna[
  I updated hydra and it doesn't work any more?
][
  // TODO: once released as 1.0 the second point would change
  - If you updated to a new _major_ version make sure to read the changelog for any breaking changes.
  - If you updated to a new _minor_ version make sure to read the changelog for any breaking changes.
  - If you updated to a new _patch_ version and used unstable APIs then should check the changelog or source code to see if the API you used is still available. Read @api to see which APIs are stable or unstable.

  If you encounter undocumented semver breakage, please report it at #issues.
]

#qna[
  Why does hydra not show a heading where I want it to?
][
  Hydra will automatically detect where showing a heading would be redundant and refuse showing it.
  See @redundancy on when that is the case, as well as how it is detected.
]

#qna[
  Why does hydra show headings even when a page starts with a new heading?
][
  There are a few possible causes:
  - If you are preparing your document and it is largely composed of empty pages with just headings, it may be caused by an introspection bug like #issue(7), this can be fixed by adding content.
  - If you use custom selectors make sure to read @custom on how to correctly define ancestors
  - If you have a rule which adds vertical leading spacing like `v(...)`it will change the location of the heading, this location is used to determine if a page starts with a heading or not. Make sure the location stays at the start of the element and includes the spacing, this can be done by surrounding the rule with a block or box, or by putting visible content before it.

      ```typst
      // do
      #show heading: it => block(v(8cm) + it)

      // don't
      #show heading: it => v(8cm) + it
      ```

  - If you encounter an issue with Hydra not detecting redundant sections, please report it at #issues
]

#qna[
  Why does hydra not show the correct heading?
][
  - Similar to the previous question, if your document is largely empty save for a few headings, you may encounter a bug like #issue(7) and can resolve it the same way.
  - As before, if you use custom selectors make sure to read @custom on how to correctly define ancestors

  If you encounter an issue with Hydra reporting the wrong active element, please report it at #issues.
]
