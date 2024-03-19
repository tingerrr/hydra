#page(
  width: auto,
  height: auto,
  margin: 0pt,
  block(
    fill: gray,
    inset: 1em,
    radius: 1em,
    grid(
      columns: 4,
      gutter: 1em,
      ..range(1, 5).map(i => image("pages/" + str(i) + ".png"))
    ),
  ),
)
