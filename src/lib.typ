#import "/src/core.typ"
#import "/src/util.typ"
#import "/src/selectors.typ"

/// An anchor used to search from. When using `hydra` ouside of the page header, this should be
/// placed inside the pge header to find the correct searching context. `hydra` always searches from
/// the last anchor it finds, if and only if it detects that it is outside of the top-margin.
#let anchor() = [#metadata(()) <hydra-anchor>]

/// Query for an element within the bounds of its ancestors.
///
/// The context passed to various callbacks contains the resolved top-margin, the current location,
/// as well as the binding direction, primary and ancestor element selectors and customized
/// functions.
///
/// This function is contextual.
///
/// - ..sel (any): The element to look for, to use other elements than headings, read the
///   documentation on selectors. This can be an element function or selector, an integer declaring
///   a heading level.
/// - prev-filter (function): A function which receives the `context` and `candidates`, and returns
///   if they are eligible for display. This function is called at most once. The primary next
///   candidate may be none.
/// - next-filter (function): A function which receives the `context` and `candidates`, and returns
///   if they are eligible for display. This function is called at most once. The primary prev
///   candidate may be none.
/// - display (function): A function which receives the `context` and candidate element to display.
/// - skip-starting (bool): Whether `hydra` should show the current candidate even if it's on top of
///   the current page.
/// - book (bool): The binding direction if it should be considered, `none` if not. If the binding
///   direction is set it'll be used to check for redundancy when an element is visible on the last
///   page. Make sure to set `binding` and `dir` if the document is not using left-to-right reading
///   direction.
/// - anchor (label, none): The label to use for the anchor if `hydra` is used outside the header.
///   If this is `none`, the anchor is not searched.
/// -> content
#let hydra(
  prev-filter: (ctx, c) => true,
  next-filter: (ctx, c) => true,
  display: core.display,
  skip-starting: true,
  book: false,
  anchor: <hydra-anchor>,
  ..sel,
) = {
  util.assert.types("prev-filter", prev-filter, function)
  util.assert.types("next-filter", next-filter, function)
  util.assert.types("display", display, function)
  util.assert.types("skip-starting", skip-starting, bool)
  util.assert.types("book", book, bool)
  util.assert.types("anchor", anchor, label, none)

  let (named, pos) = (sel.named(), sel.pos())
  assert.eq(named.len(), 0, message: util.fmt("Unexected named arguments: `{}`", named))
  assert(pos.len() <= 1, message: util.fmt("Unexpected positional arguments: `{}`", pos))

  let sanitized = selectors.sanitize("sel", pos.at(0, default: heading))

  let ctx = (
    prev-filter: prev-filter,
    next-filter: next-filter,
    display: display,
    skip-starting: skip-starting,
    book: book,
    anchor: anchor,
    primary: sanitized.primary,
    ancestors: sanitized.ancestors,
  )

  core.execute(ctx)
}
