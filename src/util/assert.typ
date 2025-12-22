#import "/src/_pkgs.typ" as _pkgs
#import "/src/util/core.typ" as _core
#import _core: queryable-functions as _queryable-functions

/// Assert that `value` is #typ.v.true.
///
/// -> none
#let assert(
  /// The truth value to check.
  ///
  /// -> any
  value,
  /// The name to use for the truth value in the assertion message.
  ///
  /// This is ignored if @cmd:eq.message is not #typ.v.auto.
  ///
  /// -> str
  name: "value",
  /// The assertion message to use, or a function to generate it if the panic occurs.
  ///
  /// -> str | function | auto
  message: auto,
) = {
  if not value {
    if message == auto {
      message = _pkgs.oxifmt().strfmt("`{}` must be `true`, but is not", name, value)
    }

    if type(message) == function {
      message = message()
    }

    panic(message)
  }
}

/// Assert that `left` and `right` are equal.
///
/// -> none
#let eq(
  /// The left-hand side of the equality check.
  ///
  /// -> any
  left,
  /// The right-hand side of the equality check.
  ///
  /// -> any
  right,
  /// The name to use for the left value in the assertion message.
  ///
  /// This is ignored if @cmd:eq.message is not #typ.v.auto.
  ///
  /// -> str
  left-name: "left",
  /// The name to use for the right value in the assertion message.
  ///
  /// This is ignored if @cmd:eq.message is not #typ.v.auto.
  ///
  /// -> str
  right-name: "right",
  /// The assertion message to use, or a function to generate it if the panic occurs.
  ///
  /// -> str | function | auto
  message: auto,
) = {
  let message = _core.or-default(
    check: auto,
    message,
    () => _pkgs.oxifmt().strfmt(
      "`{}` and `{}` must be equal, but are not (`{}` != `{}`)",
      left-name,
      right-name,
      left,
      right,
    ),
  )

  assert.eq(left, right, message: message)
}

/// Assert that `left` and `right` are not equal.
///
/// -> none
#let ne(
  /// The left-hand side of the inequality check.
  ///
  /// -> any
  left,
  /// The right-hand side of the inequality check.
  ///
  /// -> any
  right,
  /// The name to use for the left value in the assertion message.
  ///
  /// This is ignored if @cmd:eq.message is not #typ.v.auto.
  ///
  /// -> str
  left-name: "left",
  /// The name to use for the right value in the assertion message.
  ///
  /// This is ignored if @cmd:eq.message is not #typ.v.auto.
  ///
  /// -> str
  right-name: "right",
  /// The assertion message to use, or a function to generate it if the panic occurs.
  ///
  /// -> str | function | auto
  message: auto,
) = {
  let message = _core.or-default(
    check: auto,
    message,
    () => _pkgs.oxifmt().strfmt(
      "`{}` and `{}` must not be equal, but are (`{}`)",
      left-name,
      right-name,
      left,
    ),
  )

  assert.ne(left, right, message: message)
}

/// Assert that `value` is any of the given `expected-values`.
///
/// -> none
#let enum(
  /// The value to check for.
  ///
  /// -> any
  value,
  /// The expected variants of `value`.
  ///
  /// -> type
  ..expected-values,
  /// The to name use for the value in the assertion message.
  ///
  /// This is ignored if @cmd:eq.message is not #typ.v.auto.
  ///
  /// -> str
  name: "value",
  /// The assertion message to use, or a function to generate it if the panic occurs.
  ///
  /// -> str | function | auto
  message: auto,
) = {
  expected-values = expected-values.pos()
  let message = _core.or-default(
    check: auto,
    message,
    () => if expected-values.len() == 1 {
      _pkgs.oxifmt().strfmt(
        "`{}` must be `{}`, was `{}`",
        name,
        expected-values.first(),
        value,
      )
    } else {
      _pkgs.oxifmt().strfmt(
        "`{}` must be one of {}, was `{}`",
        name,
        expected-values.map(_pkgs.oxifmt().strfmt.with("`{}`")).join(", ", last: " or "),
        value,
      )
    },
  )

  assert(value in expected-values, message: message)
}

/// Assert that `value` is of any of the given `expected-types`.
///
/// -> none
#let types(
  /// The value to check for.
  ///
  /// -> any
  value,
  /// The expected types of `value`.
  ///
  /// -> type
  ..expected-types,
  /// The name to use for the value in the assertion message.
  ///
  /// This is ignored if @cmd:eq.message is not #typ.v.auto.
  ///
  /// -> str
  name: "value",
  /// The assertion message to use, or a function to generate it if the panic occurs.
  ///
  /// -> str | function | auto
  message: auto,
) = {
  let given-type = type(value)
  expected-types = expected-types
    .pos()
    .map(t => if t == none {
      type(none)
    } else if t == auto {
      type(auto)
    } else {
      t
    })
  let message = _core.or-default(
    check: auto,
    message,
    () => if expected-types.len() == 1 {
      _pkgs.oxifmt().strfmt(
        "`{}` must be a `{}`, was `{}`",
        name,
        expected-types.first(),
        given-type,
      )
    } else {
      _pkgs.oxifmt().strfmt(
        "`{}` must be one of a {}, was `{}`",
        name,
        expected-types.map(_pkgs.oxifmt().strfmt.with("`{}`")).join(", ", last: " or "),
        given-type,
      )
    },
  )

  assert(given-type in expected-types, message: message)
}

/// Assert that `element` is an element creatd by one of the given `expected-funcs`.
///
/// -> none
#let element(
  /// The value to check for.
  ///
  /// -> any
  element,
  /// The expected element functions of @cmd:element.element.
  ///
  /// -> type
  ..expected-funcs,
  /// The name to use for the value in the assertion message.
  ///
  /// This is ignored if @cmd:eq.message is not #typ.v.auto.
  ///
  /// -> str
  name: "element",
  /// The assertion message to use, or a function to generate it if the panic occurs.
  ///
  /// -> str | function | auto
  message: auto,
) = {
  let given-func = element.func()
  expected-funcs = expected-funcs.pos()
  let message = _core.or-default(
    check: auto,
    message,
    () => if expected-funcs.len() == 1 {
      _pkgs.oxifmt().strfmt(
        "`{}` must be a `{}`, was `{}`",
        name,
        expected-funcs.first(),
        given-func,
      )
    } else {
      _pkgs.oxifmt().strfmt(
        "`{}` must be one of a {}, was `{}`",
        name,
        expected-funcs.map(_pkgs.oxifmt().strfmt.with("`{}`")).join(", ", last: " or a"),
        given-func,
      )
    },
  )

  types(name, element, content, message: message)
  assert(given-func in expected-funcs, message: message)
}

/// Assert that `value` can be used in `query`.
///
#let queryable(
  /// The value to check for.
  ///
  /// -> any
  value,
  /// The name to use for the value in the assertion message.
  ///
  /// This is ignored if @cmd:eq.message is not #typ.v.auto.
  ///
  /// -> str
  name: "value",
  /// The assertion message to use, or a function to generate it if the panic occurs.
  ///
  /// -> str | function | auto
  message: auto,
) = {
  let given-type = type(value)
  let message = _core.or-default(
    check: auto,
    message,
    () => _pkgs.oxifmt().strfmt(
      "`{}` must be queryable, such as an element function, selector or label, `{}` is not queryable",
      name,
      given-type,
    ),
  )

  types(name, value, label, function, selector, message: message)

  if type(value) == function {
    let message = _core.or-default(check: auto, message, () => {
      _pkgs.oxifmt().strfmt("`{}` is not an element function, was `{}`", name, value)
    })
    assert(value in _queryable-functions, message: message)
  }
}

