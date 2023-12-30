#import "/src/core.typ"
#import "/src/util.typ"
#import "/src/selectors.typ"

/// An anchor used to search from. When using `hydra` ouside of the page header, this should be
/// placed inside the header to find the correct searching context. `hydra` always searches from the
/// last anchor it finds, if and only if it detects that it is outside of the top-margin.
#let anchor() = [#metadata(()) <hydra-anchor>]

/// Query for an element within the bounds of its ancestors.
///
/// The context passed to various callbacks contains the resolved top-margin, the current location,
/// as well as the binding direction, self and ancestor element selectors.
///
/// - ..sel (any): The element to look for, to use other elements than headings, read the
///   documentation on selectors. This can be an element function or selector, an integer declaring
///   a heading level, or a string/content declaring a range of heading levels.
/// - prev-filter (function): A function which receives the context, previous and next element and
///   returns if they are eligible for display. This function is called at most once. The next
///   element may be none.
/// - next-filter (function): A function which receives the context, previous and next element and
///   returns if they are eligible for display. This function is called at most once. The prev
///   element may be none.
/// - display (function): A function which receives the context and element to display
/// - fallback-next (bool): Whether hydra should show the current element even if it's on top of the
///   current page.
/// - binding (alignment, none): The binding direction if it should be considered, `none` if not.
///   If the binding direction is set it'll be used to check for redundancy when an element is
///   visible on the last page.
/// - paper (str): The paper size of the current page, used to calculate the top-margin.
/// - page-size (length): The smaller page size of the current page, used to calculated the
///   top-margin.
/// - top-margin (length): The top margin of the current page, used to check if the curren page has
///   an element on top.
/// - anchor (label, none): The label to use for the anchor if `hydra` is used outside the header.
///   If this is `none`, the anchor is not searched.
/// - loc (location): The location to use for the callback, if this is not given hydra calls locate
///   internally, making the return value opaque.
/// -> content
#let hydra(
  prev-filter: (ctx, c) => true,
  next-filter: (ctx, c) => true,
  display: core.display,
  fallback-next: false, // BUG: this will not look ahead if an ancestor is in the way
  binding: none,
  paper: "a4",
  page-size: auto,
  top-margin: auto,
  anchor: <hydra-anchor>,
  loc: none,
  ..sel,
) = {
  util.assert.types("prev-filter", prev-filter, function)
  util.assert.types("next-filter", next-filter, function)
  util.assert.types("anchor", anchor, label, none)
  util.assert.enum("binding", binding, left, right, none)
  util.assert.types("paper", paper, str)
  util.assert.types("page-size", page-size, str, auto)
  util.assert.types("top-margin", top-margin, str, auto)
  util.assert.types("loc", loc, location, none)

  // if margin is auto we need the page size
  if top-margin == auto {
    // if page size is auto then only paper was given
    if page-size == auto {
      if paper == auto {
        panic("Must set one of `paper`, `page-size` or `top-margin`")
      }

      page-size = util.page-sizes.at(paper, default: none)
      assert.ne(page-size, none, message: util.fmt("Unknown paper: `{}`", paper))
      page-size = page-size.values().fold(10000mm, calc.min)
    }

    top-margin = (2.5 / 21) * page-size
  }

  let (named, pos) = (sel.named(), sel.pos())
  assert.eq(named.len(), 0, message: util.fmt("Unexected named arguments: `{}`", named))
  assert(pos.len() <= 1, message: util.fmt("Unexpected positional arguments: `{}`", pos))

  let sanitized = selectors.sanitize("sel", pos.at(0, default: heading))

  let func = loc => {
    let ctx = (
      prev-filter: prev-filter,
      next-filter: next-filter,
      display: display,
      fallback-next: fallback-next,
      binding: binding,
      top-margin: top-margin,
      anchor: anchor,
      loc: loc,
      self: sanitized.self,
      ancestor: sanitized.ancestor,
    )

    core.execute(ctx)
  }

  if loc != none {
    func(loc)
  } else {
    locate(func)
  }
}
