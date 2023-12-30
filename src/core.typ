#import "/src/util.typ"

/// Get the last anchor location. Panics if the last anchor was not on the page of this context.
///
/// - ctx (context): The context from which to start.
/// -> location
#let get-anchor-pos(ctx) = {
  let starting-locs = query(selector(ctx.anchor).before(ctx.loc), ctx.loc)

  let message = (
    "No `anchor()` found while searching from outside the page header, did you forget to set",
    "`paper`/`page-size` or `top-margin`?",
  ).join(" ")

  assert.ne(starting-locs.len(), 0, message: message)

  let anchor = starting-locs.last().location()

  assert.eq(anchor.page(), ctx.loc.page(),
    message: "`anchor()` must be on every page before the first use of `hydra`"
  )

  anchor
}

/// Get the element candidates for the given context.
///
/// - ctx (context): The context for which to get the candidates.
/// -> dictionary
#let get-candidates(ctx) = {
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

  (
    self: (prev: prev, next: next),
    ancestor: (prev: prev-ancestor, next: next-ancestor),
  )
}

/// Checks if the current context is on a starting page, i.e. if the next candidates are on top of
/// this context's page.
///
/// - ctx (context): The context in which the visibility of the next candidates should be checked.
/// - candidates (dictionary): The primary and ancestor candidates.
/// -> bool
#let is-on-starting-page(ctx, candidates) = {
  let next = if candidates.self.next != none { candidates.self.next.location() }
  let next-ancestor = if candidates.ancestor.next != none { candidates.ancestor.next.location() }

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

/// Checks if the previous self candidate is still visible.
///
/// - ctx (context): The context in which the visibility of the previous self candidate should be
///   checked.
/// - candidates (dictionary): The primary and ancestor candidates.
/// -> bool
#let is-prev-visible(ctx, candidates) = {
  let prev-page-visible = if ctx.binding == left {
    calc.odd(ctx.loc.page())
  } else if ctx.binding == right {
    calc.even(ctx.loc.page())
  } else {
    return false
  }

  let prev-on-prev-page = candidates.self.prev.location().page() == ctx.loc.page() - 1

  prev-page-visible and prev-on-prev-page
}

/// Check if showing the active element would be redudnant in the current context.
///
/// - ctx (context): The context in which the redundancy of the previous self candidate should be
///   checked.
/// - candidates (dictionary): The primary and ancestor candidates.
/// -> bool
#let is-prev-redundant(ctx, candidates) = {
  let prev-visible = candidates.self.prev != none and is-prev-visible(ctx, candidates)
  let starting-page = is-on-starting-page(ctx, candidates)

  prev-visible or starting-page
}

/// Display a heading's numbering and body.
///
/// - ctx (context): The context in which the element was found.
/// - element (content): The heading to display, panics if this is not a heading.
/// -> content
#let display(ctx, element) = {
  util.assert.element("element", element, heading,
    message: "Use a custom `display` function for elements other than headings",
  )

  if element.has("numbering") and element.numbering != none {
    numbering(element.numbering, ..counter(heading).at(element.location()))
    [ ]
  }

  element.body
}

/// Execute the core logic to find and display elements for the current context.
///
/// - ctx (context): The context for which to find and display the element.
/// -> content
#let execute(ctx) = {
  if ctx.anchor != none and ctx.loc.position().y >= ctx.top-margin {
    ctx.loc = get-anchor-pos(ctx)
  }

  let candidates = get-candidates(ctx)
  let prev-eligible = candidates.self.prev != none and (ctx.prev-filter)(ctx, candidates)
  let next-eligible = candidates.self.next != none and (ctx.next-filter)(ctx, candidates)
  let prev-redundant = is-prev-redundant(ctx, candidates)

  if prev-eligible and not prev-redundant {
    (ctx.display)(ctx, candidates.self.prev)
  } else if next-eligible and ctx.fallback-next {
    (ctx.display)(ctx, candidates.self.next)
  }
}
