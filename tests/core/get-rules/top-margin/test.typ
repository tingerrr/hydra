/// Synopsis:
/// - One of height or width being `auto` means the other one is considered the
///   smaller one.
/// - Height and width being `auto` causes fallback to `A4` paper size for
///   margin calculation.

#import "/src/lib.typ": core, util

#page([], height: 5cm, width: auto, header: context {
  assert.eq(core.get-top-margin(), (2.5 / 21) * 5cm)
})

#page([], height: auto, width: 4cm, header: context {
  assert.eq(core.get-top-margin(), (2.5 / 21) * 4cm)
})

#page([], height: auto, width: auto, header: context {
  assert.eq(core.get-top-margin(), (2.5 / 21) * 210.0mm)
})
