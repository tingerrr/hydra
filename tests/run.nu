#! /usr/bin/env nu

# This is kind convoluted but get's the job done until I have time to work on a proper program for
# this.

# TODO: accept new test output
# TODO: RiiR

let root = $env.FILE_PWD | path join '..' | path expand

let c = {
  r: (ansi red_bold)
  y: (ansi yellow_bold)
  g: (ansi green_bold)
  w: (ansi white_bold)
  c: (ansi reset)
}

# show some output, optionally going back by n lines
def show [
  --go_back: int
  msg: string
] {
  let back = if $go_back == null or $go_back == 0 {
    ''
  } else {
    0..($go_back - 1) | each { ansi --escape 'F' } | str join
  }

  echo $"($back)(ansi --escape 'K')($msg)"
}

# run a single test
def one [ test: string ] {
  let typ_dir = $env.FILE_PWD | path join 'typ' | path join $test
  let ref_dir = $env.FILE_PWD | path join 'ref' | path join $test
  let diff_dir = $env.FILE_PWD | path join 'diff' | path join $test
  let output_dir = $env.FILE_PWD | path join 'out' | path join $test

  let input = $typ_dir | path join 'test.typ'
  let output = $output_dir | path join '{n}.png'

  show $"($c.y)testing($c.c) ($test)"

  try {
    show $"  ($c.y)compiling"
    rm --recursive --force $output_dir
    mkdir $output_dir
    mkdir $ref_dir
    rm --recursive --force $diff_dir
    mkdir $diff_dir
    typst compile --root $root $input $output
    show --go_back 1 $"  ($c.g)compiling succeeded"
  } catch {|err|
    show --go_back 1 $"  ($c.r)compiling failed($c.c)\n($err)"
    return
  }

  let outputs = ls $output_dir
  let refs = ls $ref_dir

  show $"  ($c.y)comparing($c.c)"
  if ($refs | length) != ($outputs | length) {
    show --go_back 1 $"  ($c.r)comparing failed($c.c)\n      references outputs differed in count \(($refs | length) != ($outputs | length)\)"
    return
  }

  mut failed_once = false
  for x in ($refs | zip $outputs | zip 1..) {
    # BUG: see https://github.com/nushell/nushell/issues/9738
    let res = do {
      run-external --redirect-stdout --redirect-stderr ($env.FILE_PWD | path join 'compare.py') ($x.0.name.0) ($x.0.name.1) ($diff_dir | path join $"($x.1).png")
     } | complete

    if $res.exit_code != 0 {
      let back = if $failed_once {
        0
      } else {
        1
      }
      show --go_back $back $"  ($c.r)comparing failed($c.c) for page ($x.1)"
      for l in ($res.stdout | str trim --char "\n" | lines) {
        show $"    ($l)"
      }
      $failed_once = true
    }
  }

  if not $failed_once {
    show --go_back 3 $"($c.g)tested($c.c) ($test)"
  }
}

# entry point, collect the files matching the filter and run them one by one
def main [ filter?: string ] {
  cd ($env.FILE_PWD | path join 'typ')

  let filter = if $filter != null { $filter } else { '' }
	let matches = (ls
		| where name =~ $filter
		| get name)

	for it in $matches {
		one ($it | str replace '.typ' '')
	}
}
