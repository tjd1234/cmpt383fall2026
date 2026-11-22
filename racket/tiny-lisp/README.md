# tiny-lisp

A very small Lisp with a whitelisted set of primitives:

| Category                  | Primitives                                              |
|---------------------------|---------------------------------------------------------|
| special forms             | `quote` `cond` `else` `let` `let*` `define` `lambda` `and` `or` |
| arithmetic and comparison | `+` `-` `*` `/` `<` `>` `<=` `>=` `=`                    |
| math functions            | `sqrt` `sin` `cos`                                      |
| logic and errors          | `not` `error`                                           |
| predicates                | `equal?` `symbol?` `number?` `boolean?` `list?` `pair?` `even?` `odd?` |
| lists                     | `cons` `list` `first` `rest` `empty?`                   |

Every other Racket feature -- `if`, `set!`, `letrec`, `eq?`/`eqv?`, `length`,
`append`, `map`/`filter`/`foldl`, string functions, structs, `require`, and so
on -- simply doesn't exist in this language. Using any of them fails with an
unbound-identifier error, exactly like using any unknown/undefined name.

See [tiny_lisp_intro.md](../tiny_lisp_intro.md) for an introduction to the
language, and the `examples` folder for some sample programs.

## Installing tiny-lisp for DrRacket

These instructions assume you are installing tiny-lisp through the DrRacket IDE.

1. **Install Racket.** Go to <https://download.racket-lang.org/>, download the
   installer for your OS, and run it with the default options.

2. **Get the `tiny-lisp` folder onto your computer.** However you get it (ZIP
   download, git clone, etc.), make sure the folder is named exactly `tiny-lisp`
   and put it somewhere easy to find, like your Desktop. It should directly
   contain `main.rkt`, `info.rkt`, `README.md`, and an `examples` folder.

3. **Register the language.** In the DrRacket IDE, go to File menu --> Install
   Package..., and then click "browse" and locate the tiny-lisp folder (the one
   containing main.rkt, info.rkt, etc.), and then click "install".

4. **Run a test program in DrRacket.** Open a new file in DrRacket, and put the
   following code in the file:

   ```lisp
   #lang tiny-lisp

   (define (inc x)
     (+ 1 x))
   ```
   
   Then click the green "Run" button in the top right corner of the DrRacket
   window, and in the interaction window type `(inc 1)` and press enter. You
   should see `2` printed out.
