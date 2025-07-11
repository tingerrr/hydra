#import "/docs/manual/util.typ": issue, issues, mantys
#import mantys: *

== Frequently Asked Questions <sec:faq>
The following questions and answers largely use the simple heading use case, but may apply to any custom elements and selectors.

#let qna(q, a) = frame(grid(
  columns: 2,
  row-gutter: 1em,
  inset: (x: 0.5em),
  [*Q*], strong(q),
  [*A*], a,
))

#qna[
  How can I use @cmd:hydra in the page footer?
][
  You can do so my placing an @cmd:anchor in the page header, see @sec:anchor.
]

#qna[
  Why does @cmd:hydra not show a heading where I want it to?
][
  @cmd:hydra will automatically detect where showing a heading would be redundant and omit it.
  See @sec:redundancy on when that is the case, as well as how it is detected.
]

#qna[
  Why does @cmd:hydra not show the correct heading?
][
  - Similar to the previous question, if your document is largely empty save for a few headings, then you may encounter a bug like #issue(7) and can resolve it the same way.
  - As before, if you use custom selectors make sure to read @sec:custom on how to correctly define ancestors

  If you encounter an issue with @cmd:hydra reporting the wrong active element, please report it at #issues.
]

#qna[
  I updated HYDRA, why doesn't it work anymore?
][
  // TODO: once released as 1.0 the second point would change
  This depends on the update you've done:
  - You updated to a new _major_ version (the `1` in `1.2.3`):
    Make sure to read the changelog for any breaking changes.
  - You updated to a new _minor_ version (the `2` in `1.2.3`):
    Make sure to read the changelog for any breaking changes.
    Once HYDRA reaches maturity (`1.0.0`) _minor_ version bumps will no longer allow breaking changes.
  - You updated to a new _patch_ version (the `3` in `1.2.3`):
    If you used unstable APIs, then there was never a guarantee that they stay the way they are across any version bump.
    Check the changelog or source code to see if the API you used is still available.
    Read @sec:api to see which APIs are stable or unstable.

    _However_, if you have not used any unstable APIs, then you've found a bug, please report it at #issues.
]

