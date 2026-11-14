// The shared document body used by all scenarios, scaled by `--input n=<int>`.
// Each section produces three headings and roughly 4-5 pages of text.
#let body() = {
  let n = int(sys.inputs.at("n", default: "16"))
  for i in range(1, n + 1) [
    = First-Level Heading #i
    #lorem(500)
    == Second-Level Heading #i
    #lorem(500)
    === Third-Level Heading #i
    #lorem(500)
  ]
}
