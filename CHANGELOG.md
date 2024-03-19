# [unreleased](https://github.com/tingerrr/hydra/releases/tags/)
## Added

## Removed

## Changed

---

# [v0.4.0](https://github.com/tingerrr/hydra/releases/tags/v0.4.0)
Almost all changes in this release are **BREAKING CHANGES**.

## Added
- internal util functions and dictionaries for recreating `auto` fallbacks used within the typst
  compiler
  - `core.get-text-dir` - returns the text direction
  - `core.get-binding` - returns the page binding
  - `core.get-page-size` - returns the page size
  - `core.get-top-margin` - returns the absolute top margin
  - `util.text-direction` - returns the text direction for a given language

## Removed
- various parameters on `hydra` have been removed
  - `binding` has been removed in favor of get rule
  - `paper` has been removed in favor of get rule
  - `page-size` has been removed in favor of get rule
  - `top-margin` has been removed in favor of get rule
  - `loc` has been removed in favor of user provided context

## Changed
- hydra now requires a minimum Typst compiler version of `0.11.0`
- `hydra` is now contextual
- most internal functions are now contextual
- the internal context dictionary now holds a `anchor-loc` instead of a `loc`
- `get-anchor-pos` has been renamed to `locate-last-anchor`
- the internal `page-sizes` dictionary was changed to function
- changed `hydra.prev-filter`, `hydra.next-filter` and `hydra.display` to be auto by default
- `hydra.dir` is now auto by default

---

# [v0.3.0](https://github.com/tingerrr/hydra/releases/tags/v0.3.0)

# [v0.2.0](https://github.com/tingerrr/hydra/releases/tags/v0.2.0)

# [v0.1.0](https://github.com/tingerrr/hydra/releases/tags/v0.1.0)