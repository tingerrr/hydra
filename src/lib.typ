#import "/src/core.typ"
#import "/src/util.typ"
#import "/src/selectors.typ"

/// An anchor used to search from. When using `hydra` ouside of the page header, this should be
/// placed inside the header to find the correct searching context. `hydra` always searches from the
/// last anchor it finds, if and only if it detects it's outside of the top-margin.
#let anchor() = [#metadata(()) <hydra-anchor>]

/// Query for an element within the bounds of its ancestors.
///
/// The context passed to various callbacks contains the resolved top-margin, the current location,
/// as well as the binding direction, self and ancestor element selectors.
///
/// - ..sel: The element to look for, to use other elements than headings, read the documentation on
///   selectors. This can be an element function or selector, an integer declaring a heading level,
///   or a string/content declaring a range of heading levels.
/// - prev-filter (function): A function which receives the context, previous and next element and
///   returns if they are eligible for display. This function is called at most once. The next
///   element may be none.
/// - next-filter (function): A function which receives the context, previous and next element and
///   returns if they are eligible for display. This function is called at most once. The prev
///   element may be none.
/// - display (function): A function which receives the context and element to display
/// - fallback-next (bool): Whether hydra should show the current element even if it's on top of the
///   current page.
/// - binding (alignment): The binding direction if it should be considered, `none` if
///   not. If the binding direction is set it'll be used to check for redundancy when an element is
///   visible on the last page.
/// - paper (str): The paper size of the current page, used to calculate the top-margin.
/// - page-size (length): The smaller page size of the current page, used to calculated the
///   top-margin.
/// - top-margin (length): The top margin of the current page, used to check if the curren page has
///   an element on top.
/// - loc (location): The location to use for the callback, if this is not given hydra calls locate
///   internally, making the return value opaque.
/// -> content
#let hydra(
  prev-filter: (ctx, c) => true,
  next-filter: (ctx, c) => true,
  display: core.display,
  fallback-next: false,
  binding: none,
  paper: "a4",
  page-size: auto,
  top-margin: auto,
  loc: none,
  ..sel,
) = {
  // we need this for the next-on-top redundancy check
  assert((paper, page-size, top-margin).filter(x => x != auto).len() >= 1,
    message: "Must set one of (`paper`, `page-size` or `top-margin`)",
  )

  // if margin is auto we need the page size
  if top-margin == auto {
    // if page size is auto then only paper was given
    if page-size == auto {
      page-size = util.page-sizes.at(paper, default: none)
      assert.ne(page-size, none, message: util.fmt("Unknown paper: `{}`", paper))
      page-size = page-size.values().fold(10000mm, calc.min)
    }

    top-margin = (2.5 / 21) * page-size
  }

  let (named, pos) = (sel.named(), sel.pos())

  assert.eq(named.len(), 0,
    message: util.fmt("Unexected named arguments: `{}`", named),
  )

  assert(pos.len() <= 1,
    message: util.fmt("Unexected positional arguments: `{}`", pos),
  )

  let unhacked = selectors.sanitize("sel", pos.at(0, default: heading))

  let func = loc => {
    let ctx = (
      binding: binding,
      top-margin: top-margin,
      loc: loc,
      self: unhacked.self,
      ancestor: unhacked.ancestor,
    )

    if ctx.loc.position().y >= ctx.top-margin {
      ctx.loc = core.get-anchor-pos(ctx)
    }

    let candidates = core.get-candidates(ctx)
    let prev-eligible = candidates.self.prev != none and prev-filter(ctx, candidates)
    let next-eligible = candidates.self.next != none and next-filter(ctx, candidates)
    let prev-redundant = core.is-prev-redundant(ctx, candidates)

    if prev-eligible and not prev-redundant {
      display(ctx, candidates.self.prev)
    } else if next-eligible and fallback-next {
      display(ctx, candidates.self.next)
    }
  }

  if loc != none {
    util.assert.type("loc", loc, location)
    func(loc)
  } else {
    locate(func)
  }
}
