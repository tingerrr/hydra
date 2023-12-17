#import "/src/util.typ"

// get the adjacent headings
#let get-adjacent-from(ctx, sel, filter) = {
  if ctx.loc.position().y >= ctx.top-margin {
    let starting-locs = query(selector(<hydra-anchor>).before(ctx.loc), ctx.loc)
    assert.ne(starting-locs.len(), 0,
      message: "No `hydra-anchor()` found while searching from outside the page header",
    )

    ctx.loc = starting-locs.last().location()
  }

  let prev = query(sel.before(ctx.loc), ctx.loc).filter(x => filter(ctx, x) and util.level-filter(ctx, x))
  let next = query(sel.after(ctx.loc), ctx.loc).filter(x => filter(ctx, x) and util.level-filter(ctx, x))

  let prev = if prev != () { prev.last() }
  let next = if next != () { next.first() }

  (prev, next, ctx.loc)
}

#let check-scope(prev, next, loc, sel, level) = {
  if level == none {
    return (true, true)
  }
  let scope-level = calc.max(..level)

  let (p, n) = (sel, sel)
  // modify these two selectors to the intervals between previous and loc, and between loc and next respectively
  if prev != none {
    p = p.after(prev.location(), inclusive: false)
  }
  p = p.before(loc, inclusive: false)
  n = n.after(loc, inclusive: false)
  if next != none {
    n = n.before(next.location(), inclusive: false)
  }

  // check that no headings in these two intervals are of equal or higher priority
  let (prev-in-scope, next-in-scope) = (p, n).map(x => query(x, loc).filter(y => y.level <= scope-level).len() == 0)

  (prev-in-scope, next-in-scope)
}

// check if the next heading is on the current page
#let is-redundant(ctx, prev, next) = {
  let is-next-on-top = (
    next.location().page() == ctx.loc.page()
      and next.location().position().y <= ctx.top-margin
  )

  let is-prev-visible = (
    ctx.is-book
      and calc.odd(ctx.loc.page()) and prev.location().page() == ctx.loc.page() - 1
  )

  is-next-on-top or is-prev-visible
}

// display the heading as closely as it occured at the given loc
#let display(ctx, element) = {
  util.assert-element(element, heading,
    message: "Use a custom `display` function for elements other than headings",
  )

  if element.has("numbering") and element.numbering != none {
    numbering(element.numbering, ..counter(heading).at(element.location()))
    [ ]
  }

  element.body
}
