# tiny-lisp

A very small Lisp with a whitelisted set of primitives:

```
define  cond  else  and  or  not  empty?  first  rest  cons  list  quote
equal?  +  -  *  let  lambda
```

Every other Racket binding -- `if`, `/`, `eq?`/`eqv?`/`=`,
`let*`/`letrec`, `set!`, `map`/`filter`/`foldl`, strings, structs,
`require`, and so on -- simply doesn't exist in this language. Using
any of them fails with an unbound-identifier error, exactly like
using any unknown/undefined name.

## Using tiny-lisp with DrRacket (for students)

This section assumes you've never used Racket, Lisp, or a
command-line/terminal window before. It walks through everything
needed, once per computer.

### 1. Install Racket

DrRacket comes bundled with Racket itself, so there's only one thing
to install:

1. Go to <https://download.racket-lang.org/> and download the
   installer for your computer (Windows/Mac/Linux).
2. Run the installer and accept the defaults.

That's it — you now have both `DrRacket` (the app you'll use to write
and run programs) and a few small command-line tools that work behind
the scenes.

### 2. Get the tiny-lisp code from GitHub

This project lives on GitHub. Get it onto your computer with
whichever of these is easier for you:

**Option A — Download ZIP (no git required):**
1. Go to the tiny-lisp GitHub page (your instructor will share the
   link).
2. Click the green **Code** button, then **Download ZIP**.
3. Find the downloaded file (usually in your Downloads folder) and
   double-click it to unzip it.
4. Move the resulting folder to your **Desktop**. GitHub names it
   something like `tiny-lisp-main` — rename it back to exactly
   `tiny-lisp`.

**Option B — `git clone` (if you already use git):**
```bash
git clone <the tiny-lisp GitHub URL> tiny-lisp
```
Run this from wherever you want the folder to end up (e.g. your
Desktop) — naming the target `tiny-lisp` at the end guarantees it's
named correctly, so there's no rename step.

Either way, you should end up with a folder named exactly `tiny-lisp`
that directly contains this README, `main.rkt`, an `examples` folder,
and so on — not nested inside another folder.

### 3. One-time setup: tell Racket that tiny-lisp exists

This is the only slightly technical step, and you only ever do it
once per computer. It means opening a plain text window called a
*terminal* (for typing commands instead of clicking), typing one
command, and pressing Enter.

**On macOS:**
1. Press `Cmd+Space`, type `Terminal`, and press Enter.
2. Type `cd Desktop` and press Enter.
3. Type `raco pkg install --link tiny-lisp` and press Enter.

**On Windows:**
1. Press the Windows key, type `cmd`, and press Enter.
2. Type `cd Desktop` and press Enter.
3. Type `raco pkg install --link tiny-lisp` and press Enter.

You'll see some text scroll by, ending with something like
`tiny-lisp was successfully installed` or `... installed`. That's
normal, and it means it worked.

**If you see `command not found` or `'raco' is not recognized`:**
Racket didn't finish installing correctly, or your computer needs a
restart after installing it (this refreshes what commands it knows
about) — restart and try step 3 again.

**If you run the command again by accident:** nothing bad happens —
Racket just replies `package is already installed` and does nothing
further.

This step only needs to happen once per computer — not once per
program. Once it's done, both DrRacket (below) and the `racket`
command in a terminal can run any `#lang tiny-lisp` file. If you ever
want to remove tiny-lisp from a computer, the opposite command is
`raco pkg remove tiny-lisp`.

### 4. Open and run a tiny-lisp program in DrRacket

1. Open the **DrRacket** application (search for it the same way you'd
   open any other app).
2. Go to **File → Open...** and pick a `.rkt` file from the
   `tiny-lisp/examples` folder (or one your instructor gave you).
3. Every tiny-lisp file starts with the line `#lang tiny-lisp` at the
   very top — DrRacket reads that line and automatically knows how to
   run it. You don't need to change any settings.
4. Click the green **Run** button near the top-right of the window.
5. The bottom half of the window (the **Interactions** area) shows
   the result of running your program.

To write your own program: **File → New**, type `#lang tiny-lisp` as
the first line, write your code underneath, save it somewhere with a
`.rkt` file name (e.g. `myprogram.rkt`), then click **Run**.

### 5. What errors look like

If your program uses something that isn't part of tiny-lisp (say,
`if`, or `map`), DrRacket will show a red error like:

```
if: unbound identifier
  in: if
```

This isn't a mistake in DrRacket or a typo you need to hunt for in
the usual sense — it means that identifier genuinely doesn't exist in
tiny-lisp. See the primitive list at the top of this file for what
*is* available.

## Design philosophy

tiny-lisp is meant to be a small version of Lisp that intentionally
avoids providing various features, so that they can be implemented as
exercises.

The primitive set covers just enough to write and take apart list
data and branch on it: `cond`/`else` for branching, `empty?`/`first`/
`rest`/`cons`/`list`/`quote` for building and destructuring lists,
`and`/`or`/`not` for combining booleans, `equal?`/`+`/`-`/`*` for
comparison and basic arithmetic, and `let`/`lambda` for local bindings
and higher-order functions.

Several of these are not strictly necessary, in the sense that they
can be derived from the rest of the language: `list` is `cons` and
`quote` chained together, `not`/`and`/`or` are each a `cond` with two
clauses, and `let` is sugar for an immediate `lambda` application.
They're kept as built-in conveniences rather than left as exercises,
but deriving any of them from the smaller kernel is a reasonable
exercise in its own right.

`if`, `let*`/`letrec`, `set!` (so, no mutation), and built-in
`map`/`filter`/`foldl` are left out entirely, to be implemented (or
done without) as exercises. `/` is excluded on the same principle but
for a different reason: it immediately raises exact rationals and
division-by-zero as issues, which is more of Racket's numeric tower
than this language engages with -- `+`, `-`, and `*` stay safely
within the integers.

See [examples/ok-list-ops.rkt](examples/ok-list-ops.rkt) (append,
reverse, list-of-lists emptiness checks), [examples/ok-count-and-member.rkt](examples/ok-count-and-member.rkt)
(counting and membership, using `+` and `equal?`), [examples/ok-higher-order.rkt](examples/ok-higher-order.rkt)
(a user-defined `my-map` driven by `lambda`, plus `let` and `-`), and
[examples/ok-multiply.rkt](examples/ok-multiply.rkt) (`product`,
`factorial`, and squaring a list via `*`) for what's expressible, and
the `examples/bad-*.rkt` files for things that are deliberately *not*
expressible.

## How it works (optional reading)

This section is entirely optional — nothing here is needed to write
or run tiny-lisp programs. It's for anyone curious how a language
like this gets built at all.

Racket is specifically designed for creating other languages: writing
a new `#lang` is a standard, well-supported thing to do in Racket, in
a way that it generally isn't in most other programming languages.
tiny-lisp is a small, direct use of that: [`main.rkt`](main.rkt) is
the entire language module. It works as a whitelist: it `require`s
just the specific bindings listed above from `racket/base` and
`racket/list`, and `provide`s exactly those back out (plus the
handful of reader/expander forms every language needs:
`#%module-begin`, `#%app`, `#%datum`, `#%top`, `#%top-interaction`).
Any identifier not in that list is simply never bound, so referencing
it fails the same way referencing any other unknown/undefined name
would. [`lang/reader.rkt`](lang/reader.rkt) makes `#lang tiny-lisp`
parse with the ordinary S-expression reader.

## Running from a terminal instead of DrRacket (optional)

DrRacket isn't required — anyone comfortable with a terminal can run
a `#lang tiny-lisp` file with the `racket` command directly, once the
one-time setup above has been done. This is the same install, the
same language, and the same files; it's just a second way to run
them, not an additional step. For example, from inside the `tiny-lisp`
folder:

```bash
racket examples/ok-list-ops.rkt         # runs fine
racket examples/ok-count-and-member.rkt # runs fine (+, equal?)
racket examples/ok-higher-order.rkt     # runs fine (-, let, lambda)
racket examples/ok-multiply.rkt         # runs fine (*)
racket examples/bad-uses-if.rkt         # fails: `if` is unbound
racket examples/bad-uses-divide.rkt     # fails: `/` is unbound
racket examples/bad-uses-set!.rkt       # fails: `set!` is unbound
```

## Changing the primitive set

Edit the two `only-in`/`provide` lists in [`main.rkt`](main.rkt) --
add an identifier there (importing it from wherever it's really
defined, e.g. `racket/base` for `+` or `equal?`) to allow it, or
remove one to take it away.
