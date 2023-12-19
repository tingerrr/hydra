#import "/src/util.typ"

// get the adjacent headings
#let get-candidates(ctx) = {
  if ctx.loc.position().y >= ctx.top-margin {
    let starting-locs = query(selector(<hydra-anchor>).before(ctx.loc), ctx.loc)
    assert.ne(starting-locs.len(), 0,
      message: "No `hydra-anchor()` found while searching from outside the page header, did you forget to set `paper`/`page-size` or `top-margin`?",
    )

    ctx.loc = starting-locs.last().location()
  }

  let look-behind = selector(ctx.self.func).before(ctx.loc)
  let look-ahead = selector(ctx.self.func).after(ctx.loc)

  let prev-ancestor = none
  let next-ancestor = none

  if ctx.ancestor != none {
    let prev = query(selector(ctx.ancestor.func).before(ctx.loc), ctx.loc)
    let next = query(selector(ctx.ancestor.func).after(ctx.loc), ctx.loc)

    if ctx.ancestor.filter != none {
      prev = prev.filter(x => (ctx.ancestor.filter)(ctx, x))
      next = next.filter(x => (ctx.ancestor.filter)(ctx, x))
    }

    if prev != () {
      prev-ancestor = prev.last()
      look-behind = look-behind.after(prev-ancestor.location())
    }

    if next != () {
      next-ancestor = next.first()
      look-ahead = look-ahead.before(next-ancestor.location())
    }
  }

  let prev = query(look-behind, ctx.loc)
  let next = query(look-ahead, ctx.loc)

  if ctx.self.filter != none {
    prev = prev.filter(x => (ctx.self.filter)(ctx, x))
    next = next.filter(x => (ctx.self.filter)(ctx, x))
  }

  let prev = if prev != () { prev.last() }
  let next = if next != () { next.first() }

  (prev, next, prev-ancestor, next-ancestor, ctx.loc)
}

// checks if the current context is on a starting page
#let is-on-starting-page(ctx, next, next-ancestor) = {
  next = if next != none { next.location() }
  next-ancestor = if next-ancestor != none { next-ancestor.location() }

  let next-starting = if next != none {
    next.page() == ctx.loc.page() and next.position().y <= ctx.top-margin
  } else {
    false
  }

  let next-ancestor-starting = if next-ancestor != none {
    next-ancestor.page() == ctx.loc.page() and next-ancestor.position().y <= ctx.top-margin
  } else {
    false
  }

  next-starting or next-ancestor-starting
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

// check if showing the active element woudl be redudnant int the current
#let is-redundant(ctx, prev, next, next-ancestor) = {
  (prev != none and is-prev-visible(ctx, prev)) or is-on-starting-page(ctx, next, next-ancestor)
}

// display the heading as closely as it occured at the given loc
#let display(ctx, element) = {
  util.assert-element("element", element, heading,
    message: "Use a custom `display` function for elements other than headings",
  )

  if element.has("numbering") and element.numbering != none {
    numbering(element.numbering, ..counter(heading).at(element.location()))
    [ ]
  }

  element.body
}
