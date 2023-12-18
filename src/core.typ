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

  let look-behind = sel.before(ctx.loc)
  let look-ahead = sel.after(ctx.loc)

  if ctx.prev-higher != none {
    look-behind = look-behind.after(ctx.prev-higher.location())
  }

  if ctx.next-higher != none {
    look-ahead = look-ahead.before(ctx.next-higher.location())
  }

  let prev = query(look-behind, ctx.loc).filter(x => filter(ctx, x))
  let next = query(look-ahead, ctx.loc).filter(x => filter(ctx, x))

  let prev = if prev != () { prev.last() }
  let next = if next != () { next.first() }

  (prev, next, ctx.loc)
}

// checks if the next heading is on top of the current page
#let is-next-on-top(ctx, next) = {
  (next.location().page() == ctx.loc.page()
    and next.location().position().y <= ctx.top-margin)
}

// checks if the previous heading is still visible
#let is-prev-visible(ctx, prev) = {
  if ctx.binding == left {
    calc.odd(ctx.loc.page())
  } else if ctx.binding == right {
    calc.even(ctx.loc.page())
  } else {
    false
  } and prev.location().page() == ctx.loc.page() - 1
}


// check if the next heading is on the current page
#let is-redundant(ctx, prev, next) = {
  ((prev != none and is-prev-visible(ctx, prev))
    or (next != none and is-next-on-top(ctx, next)))
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
