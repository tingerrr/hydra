#let _std-type = type

#import "/src/util/core.typ" as _core
#import "/src/util/queryable-functions.typ": queryable-functions as _queryable-functions

/// Assert that `value` is of a given `expected-type`.
///
/// - name (str): The name use for the value in the assertion message.
/// - value (any): The value to check for.
/// - expected-type (type): The expected type of `value`.
#let type(name, value, expected-type, message: auto) = {
  let given-type = _std-type(value)
	expected-type = if expected-type == none { _std-type(none) } else { expected-type }
  let message = _core.or-default(check: auto, message, () => {
    _core.fmt("`{}` must be `{}`, was `{}`", name, expected-type, given-type)
  })

  assert.eq(given-type, expected-type, message: message)
}

/// Assert that `value` is of any of the givn `expected-types`.
///
/// - name (str): The name use for the value in the assertion message.
/// - value (any): The value to check for.
/// - expected-types (type): The expected types of `value`.
#let types(name, value, expected-types, message: auto) = {
  let given-type = _std-type(value)
  expected-types = expected-types.map(t => if t == none { _std-type(none) } else { t })
  let message = _core.or-default(check: auto, message, () => {
    _core.fmt("`{}` must be one of `{}`, was `{}`", name, expected-types, given-type)
  })

  assert(given-type in expected-types, message: message)
}

/// Assert that `element` is an element of the given `expected-func`.
///
/// - name (str): The name use for the value in the assertion message.
/// - element (any): The value to check for.
/// - expected-func (type): The expected element function of `element`.
#let element(name, element, expected-func, message: auto) = {
  let given-func = element.func()
  let message = _core.or-default(check: auto, message, () => {
    _core.fmt("`{}` must be a `{}`, was `{}`", name, expected-func, given-func)
  })

  type(name, element, content, message: message)
  assert.eq(given-func, expected-func, message: message)
}

/// Assert that `value` can be used in `query`.
///
/// - name (str): The name use for the value in the assertion message.
/// - value (any): The value to check for.
#let queryable(name, value, message: auto) = {
  let given-type = _std-type(value)
  let message = _core.or-default(check: auto, message, () => _core.fmt(
    "`{}` must be queryable, such as an element function, selector or label, `{}` is not queryable",
    name,
    given-type,
  ))

  types(name, value, (label, function, selector), message: message)

  if _std-type(value) == function {
    let message = _core.or-default(check: auto, message, () => {
      _core.fmt("`{}` is not an element function, was `{}`", name, value)
    })
    assert(value in _queryable-functions, message: message)
  }
}

