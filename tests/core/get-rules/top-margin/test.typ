/// Synopsis:
/// - An auto margin uses the `min * 21 / 2.5` fallback.
/// - An auto page size uses the smaller page size.
/// - A double auto page size uses the a4 page size.
/// - A percentage margin is applied to the page height, not to the smaller page
///   length.

#import "/src/lib.typ": hydra, core

#let factor = (21 / 2.5)
#let a4-width = 210.0mm

// auto margin fallback
#page(
  height: 20cm,
  width: 10cm,
  margin: auto,
  context assert.eq(core.get-top-margin(), page.width / factor),
)

#page(
  height: 10cm,
  width: 20cm,
  margin: auto,
  context assert.eq(core.get-top-margin(), page.height / factor),
)

// auto page size fallback
#page(
  height: auto,
  width: 10cm,
  margin: auto,
  context assert.eq(core.get-top-margin(), page.width / factor),
)

#page(
  height: 10cm,
  width: auto,
  margin: auto,
  context assert.eq(core.get-top-margin(), page.height / factor),
)

#page(
  height: auto,
  width: auto,
  margin: auto,
  context assert.eq(core.get-top-margin(), a4-width / factor),
)

// percentage application
#page(
  height: 20cm,
  width: 10cm,
  margin: 10%,
  context assert.eq(core.get-top-margin(), page.height * 10%),
)

#page(
  height: 10cm,
  width: 20cm,
  margin: 10%,
  context assert.eq(core.get-top-margin(), page.height * 10%),
)

// dictionary
#page(
  height: 20cm,
  width: 10cm,
  margin: (top: 10%, rest: 20%),
  context assert.eq(core.get-top-margin(), page.height * 10%),
)

#page(
  height: 10cm,
  width: 20cm,
  margin: (top: 10%, rest: 20%),
  context assert.eq(core.get-top-margin(), page.height * 10%),
)
