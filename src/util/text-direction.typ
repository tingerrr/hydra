/// Returns the text direction for a given language, defaults to `ltr` for unknown languages.
///
/// Source: github:typst/typst#9646a13 crates/typst/src/text/lang.rs:L50-57
///
/// lang (str): The languge to get the text direction for.
/// -> direction
#let text-direction(lang) = if lang in (
  "ar", "dv", "fa", "he", "ks", "pa", "ps", "sd", "ug", "ur", "yi",
) { rtl } else { ltr }
