#let package = toml("/typst.toml").package

#let load-examples(example) = {
  let path = "/doc/examples/" + example
  // NOTE: this breaks for docs with more than 10 pages, but at this point the example is too large
  //       anyway
  let example = (v, i) => image(path + "/out/" + v + str(i) + ".png")
  let r = range(1, toml(path + "/out.toml").pages + 1)

  (
    a: r.map(i => example("a", i)),
    b: r.map(i => example("b", i)),
  )
}

#let show-examples(examples, width: 50%) = block(
  width: width,
  fill: gray,
  inset: 0.5em,
  grid(columns: (1fr, 1fr), gutter: 0.5em, align(center + horizon)[Binding], ..examples),
)

#let issue(num) = link(package.repository + "/issues/" + str(num))[hydra\##num]

#let raw-bg = gray.lighten(50%)
#let bbox = box.with(inset: (x: 0.25em), outset: (y: 0.25em), radius: 0.25em)

