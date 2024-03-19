// Synopsis:
// - for a single auto size the other is automatically the smaller one and is used for the maring
//   calc
// - for both auto, a4 lengths are assumed

#import "/src/lib.typ": core, util

#set page(
  height: 5cm,
  width: auto,
  header: context {
    assert.eq(core.get-top-margin(), (2.5 / 21) * 5cm)
  }
)
A

#set page(
  height: auto,
  width: 4cm,
  header: context {
    assert.eq(core.get-top-margin(), (2.5 / 21) * 4cm)
  }
)
B

#set page(
  height: auto,
  width: auto,
  header: context {
    assert.eq(core.get-top-margin(), (2.5 / 21) * 210.0mm)
  }
)
C
