// Synopsis:
// - a change in styles mid page is not observed in the footer
// - this assures that with an anchor, the resolved styles will still be correct if hydra is used
//   in the footer
// - text dir is the only style which could change between an anchor and a hdyra call
// - given an in text use of hydra, this would cause unexpected behavior

#import "/src/lib.typ": core

#set page(
  paper: "a7",
  header: context core.get-text-dir(),
  footer: context core.get-text-dir(),
)

#lorem(1)

#set text(dir: rtl)

#context core.get-text-dir()

#lorem(1)
