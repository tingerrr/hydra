#import "@preview/mantys:1.0.0"

#let package = toml("/typst.toml").package

#let load-examples(example) = {
  let path = "/docs/examples/" + example
  let example = (v, i) => image(path + "/out/" + v + str(i) + ".png")
  let r = range(1, 4)

  (
    a: r.map(i => example("a", i)),
    b: r.map(i => example("b", i)),
  )
}

#let show-examples(examples, theme: mantys.themes.default) = block(
  radius: 0.25em,
  fill: theme.muted.bg,
  inset: 0.5em,
  grid(columns: (1fr, 1fr), gutter: 0.5em, align(center + horizon)[Binding], ..examples),
)

#let issue(num) = text(eastern, link(package.repository + "/issues/" + str(num))[hydra\##num])

#let issues = text(eastern, link(package.repository + "/issues/")[GitHub:tingerrr/hydra])

#let bbox = box.with(inset: (x: 0.25em), outset: (y: 0.25em), radius: 0.25em)
