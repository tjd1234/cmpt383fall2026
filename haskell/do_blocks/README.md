# "Simple" Haskell Programs

The follow programs show some "simple" programs that written in Haskell that
would appear it the beginning of a programming course using a language like
Python or C.

Doing input/output and sequencing operations in Haskell is different from
languages like Python and C because Haskell uses pure functions and immutable
data. Recall that a pure function is a function that does not have any side
effects (like printing to the screen), and always returns the same output for
the same input.

For example, imagine you have a Haskell function `getStringFromUser`. What value
does it return? It *cannot* return a `String` because, according to the rules of
pure functions, it must always return the same output for the same input. But
then it would be useless in practice because it almost always returns a
different value (i.e. whatever the user types).

Dealing with I/O and sequencing operations in purely functions languages is a
significant challenge. Haskell solves this by using a special type called `IO`
that represents a computation that can have side effects. Essentially, functions
that return `IO` values are not pure functions, and can do computations with
side effects.

The following example programs show some simple and practical programs that
demonstrate these concepts.

- [helloWorld.hs](helloWorld.hs): prints "Hello, World!" to the console
- [greetUser.hs](greetUser.hs): asks the user for their name and greets them
- [repeatName.hs](repeatName.hs): asks the user for their name and number and
  prints it that many times
- [oneRandomRoll.hs](oneRandomRoll.hs): rolls a 6-sided die and prints the result
- [threeRandomRolls.hs](threeRandomRolls.hs): rolls three 6-sided dice and prints
  the results
- [NrandomRolls.hs](NrandomRolls.hs): asks the user for a number of dice to
  roll, rolls them, printing the results
- [rollUntilSix.hs](rollUntilSix.hs): rolls a 6-sided die until a 6 is rolled,
  printing the number of rolls it took
