#import "/src/core.typ"
#import "/src/util.typ"

#let hydra-anchor() = [#metadata(()) <hydra-anchor>]

#let hydra(
  sel: heading,
  sel-higher: auto,
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
  let (sel, filter) = util.into-sel-filter-pair(sel)

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
      binding: binding,
      top-margin: top-margin,
      loc: loc,
      prev-higher: none,
      next-higher: none,
    )

    if sel-higher == auto {
      if repr(sel).starts-with("heading.where") {
        let unhacked = util.unhack-selector(sel)

        assert("level" in unhacked.fields, message: "`sel` must select over `heading.level`" + repr(unhacked.fields))

        let (sel-higher, filter-higher) = util.into-sel-filter-pair(
          unhacked.func.where(level: unhacked.fields.level - 1)
        )

        let (prev-higher, next-higher, _) = core.get-adjacent-from(ctx, sel-higher, filter-higher)
        ctx.prev-higher = prev-higher
        ctx.next-higher = next-higher
      }
    } else {
      let (sel-higher, filter-higher) = util.into-sel-filter-pair(sel-higher)
      let (prev-higher, next-higher, _) = core.get-adjacent-from(ctx, sel-higher, filter-higher)
      ctx.prev-higher = prev-higher
      ctx.next-higher = next-higher
    }

    let (prev, next, loc) = core.get-adjacent-from(ctx, sel, filter)
    ctx.loc = loc

    let prev-eligible = prev != none and prev-filter(ctx, prev, next)
    let next-eligible = next != none and next-filter(ctx, prev, next)
    let prev-redundant = core.is-redundant(ctx, prev, next)

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
