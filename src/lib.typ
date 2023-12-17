#import "/src/core.typ"
#import "/src/util.typ"

#let hydra-anchor() = [#metadata(()) <hydra-anchor>]

#let hydra(
  sel: heading,
  level: none,
  prev-filter: (ctx, p, n) => true,
  next-filter: (ctx, p, n) => true,
  display: core.display,
  fallback-next: false,
  is-book: false,
  paper: "a4",
  page-size: auto,
  top-margin: auto,
  loc: none,
) = {
  let (sel, filter) = util.into-sel-filter-pair(sel)
  let level = util.into-levels-array(level)

  assert((paper, page-size, top-margin).filter(x => x != auto).len() >= 1,
    message: "Must set one of (`paper`, `page-size` or `top-margin`)",
  )

  if top-margin == auto {
    if page-size == auto {
      page-size = util.page-sizes.at(paper, default: none)
      assert.ne(page-size, none, message: util.oxi.strfmt("Unknown paper: `{}`", paper))
      page-size = page-size.values().fold(10000mm, calc.min)
    }

    top-margin = (2.5 / 21) * page-size
  }

  let func = loc => {
    let ctx = (
      is-book: is-book,
      top-margin: top-margin,
      level: level,
      loc: loc,
    )

    let (prev, next, loc) = core.get-adjacent-from(ctx, sel, filter)
    ctx.loc = loc

    let (prev-in-scope, next-in-scope) = core.check-scope(prev, next, loc, sel, level)

    // TODO also check if there is a higher-level heading at the top of the page

    let prev-eligible = prev != none and prev-filter(ctx, prev, next) and prev-in-scope
    let next-eligible = next != none and next-filter(ctx, prev, next) and next-in-scope
    let prev-redundant = (
      prev-eligible
        and next-eligible
        and ctx.top-margin != none
        and core.is-redundant(ctx, prev, next)
    )

    if prev-eligible and not prev-redundant {
      display(ctx, prev)
    } else if fallback-next and next-eligible {
      display(ctx, next)
    }
  }

  if type(loc) == location {
    func(loc)
  } else {
    locate(func)
  }
}
