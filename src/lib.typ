#import "/src/core.typ"
#import "/src/util.typ"

#let hydra-anchor() = [#metadata(()) <hydra-anchor>]

#let hydra(
  sel: heading,
  prev-filter: (ctx, p, n) => true,
  next-filter: (ctx, p, n) => true,
  display: core.display,
  fallback-next: false,
  binding: none,
  paper: "a4",
  page-size: auto,
  top-margin: auto,
  loc: none,
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
      assert.ne(page-size, none, message: util.oxi.strfmt("Unknown paper: `{}`", paper))
      page-size = page-size.values().fold(10000mm, calc.min)
    }

    top-margin = (2.5 / 21) * page-size
  }

  let func = loc => {
    let unhacked = util.unhack("sel", sel)

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
    let (prev, next, next-ancestor) = (
      candidates.self.prev,
      candidates.self.next,
      candidates.ancestor.next,
    )

    let prev-eligible = prev != none and prev-filter(ctx, prev, next)
    let next-eligible = next != none and next-filter(ctx, prev, next)
    let prev-redundant = core.is-redundant(ctx, prev, next, next-ancestor)

    if prev-eligible and not prev-redundant {
      display(ctx, prev)
    } else if next-eligible and fallback-next {
      display(ctx, next)
    }
  }

  if loc != none {
    util.assert-type("loc", loc, location)
    func(loc)
  } else {
    locate(func)
  }
}
