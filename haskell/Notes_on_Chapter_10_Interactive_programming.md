## The Problem

Haskell's functions are **pure**: given the same input, a pure function will
*always* return the same result because it depends only on its input. Pure
functions also have no **side effects**, i.e. calling a pure function never
changes the value of a variable outside the function.

Pure functions are often easier to reason about and test than impure functions,
and so as a general rule you should prefer pure functions over impure functions.

But sometimes you don't have a choice. For example, if you want to do things
like read or wrote data, or generate random numbers, you need to use impure
functions. For example:

But in programming, many functions are useful for their side effects. For
example:

- C's `printf` function causes the side-effect of displaying characters on the
  terminal, and so it's not pure.
- C's `rand()` function doesn't always return the same number every time you
  call it, so it's not pure.
- Pythons `time.time()` function returns the current time, and so usually it
  returns different values every time you call it.

We've been intentionally avoiding examples like these because there is no
obvious way to deal with impure functions in Haskell. Most languages don't
distinguish between pure and impure functions, and freely mix them together.

Haskell takes a very different approach to impure functions, and only allows
them in certain situations.

## Haskell's Approach to Impure Functions

Lets gain some intuition for how Haskell deals with impure functions. The text
asks you to imagine an interactive Haskell function, e.g. a chatbot that the
user interacts with through text. In Haskell, you *can't* implement an
interesting chatbot with the signature `String -> String` because the function
will be pure, meaning it will always return the same string for the same input.

Now imagine that the chatbot function has the type `World -> (String, World)`.
The `World` type is a made-up type (just for this example) that represents the
everything the chatbot knows about, e.g. the current date/time, rules for
answering questions, a list of all previous inputs to the chatbot, and so on. So
the input to chatbot is a state of the `World`, and the output is the chatbot's
reply of type `String`, plus a *new* `World` state that describes the new state
of the world after the chatbot has replied. Instead of *modifying* the world,
the chatbot *makes a new copy* of the world that is changed according to the
chatbot's reply.

`World` is not a real type. Instead, as Haskell chatbot would use the type `IO
String`, which you could intuitively imagine as being defined like this:

```haskell
type IO String = World -> (String, World)
```

`IO` stands for input/output, because one of the major applications of this kind
of type is input and output.

A function of type `IO a` can be thought of as taking the relevant state of the
world as input, and returning a value (of type `a`) plus an updated state of the
world as output. Any side-effects of the function are recorded in this changed
world. Intuitively, the function *doesn't change* the world, but instead returns
a brand new modified copy of the world.

Expressions of type `IO a` are called **actions**. For example, `IO String` is
the type of an *action* that returns a `String`, and `IO Int` is the type of an
*action* that returns an `Int`. The special action `IO ()` is the type of an
action that doesn't return a value, but does some side-effect (e.g. a print a
string to the screen).

Again, to be clear, Haskell *doesn't* have a type like `World` that represents
the state of the world. The type `IO a` is considered primitive in Haskell, i.e.
we can't implement it within Haskell.

## Basic actions

The standard action `getChar :: IO Char` reads a character from the keyboard.
When called, it waits for the user to type a character:

```haskell
> getChar
t't'
> getChar
!'!'
```

`getChar` *does not* return a `Char`, it returns an `IO Char`. There's no way to
get the `Char` out of the `IO Char` using pure functions.

The standard action `putChar :: Char -> IO ()` takes a character as input and
writes it to the screen:

```haskell
> putChar '?'
?
```

`putChar` doesn't *return* a `Char`. We know this because it's return type is
`IO ()`, which means `putChar` has a side-effect (printing a character on the
screen), and returns no value after it's done. `putChar ?` *looks* like it's
returning a value, but it's not: what you're seeing is the *action* `putChar`
performs of printing the character.

Finally, the standard action `return :: a -> IO a` takes a value of type `a` as
input and returns it as an `IO a` without performing any interaction with the
user. If you evaluate `return v` in the interpreter, it looks like it is
returning the given value, e.g.:

```haskell
> return 'a'
'a'
> return "cow"
"cow"
> return 4
4
```

But that's just the interpreter being helpful: the true return type is `IO a`.
For example:

```haskell
> 2 + 3
5
> 2 + (return 3)
<interactive>:40:1: error:
    • Ambiguous type variable ‘m0’ arising from a use of ‘print’
      prevents the constraint ‘(Show (m0 Integer))’ from being solved.
```

The `return` action converts a value of type `a` into a value of type `IO a`.
Importantly, it's not possible to go the other way using pure functions, i.e. we
**cannot** write a pure function of type `IO a -> a` that extracts the `a` value
from `IO a`. Once a value is in `IO a`, it is stuck there forever.

## Sequencing: do-notation

**do-notation** lets Haskell do one, or more actions, in a sequence. For
example, this reads 3 characters from the terminal, and then prints them in
reverse order:

```haskell
test1 = do a <- getChar
           b <- getChar
           c <- getChar
           putChar '\n'
           putChar c
           putChar b
           putChar a
           putChar '\n'

> test1
cat
tac
```

The meaning is fairly straightforward: three characters are read in and stored
in the variables `a`, `b`, and `c`, and then they are printed in reverse order.
An expression of the form `a <- getChar` is called a **generator**. It calls
`getChar` and puts the resulting `Char` into `a`. 

**Important** In the do-expression above, `a` contains a `Char`, *not* an `IO
Char`. Inside do-expressions, we operate directly on values without worrying
about the `IO` part. The generator `a <- getChar` is impure because `a` could be
assigned different values each time it is called. *Within* do-expressions, this
impurity is allowed. It's as if the do-notation parts of a program are "impure
zones" that wall-off the impurity from the rest of the program. Crucially,
there's no way to access the value of `a` outside the do-notation.

## Derived primitives

The expression `putChar '\n'` is used a couple of times in `test1`, so lets
write a function that does the same thing. First, note that the type of `putChar
'\n'` is `IO ()`, i.e. an action that doesn't return a value:

```haskell
> :t putChar '\n'
putChar '\n' :: IO ()
```

So we can write this function:

```haskell
newline :: IO ()
newline = putChar '\n'
```

This lets us write:

```haskell
test2 = do a <- getChar
           b <- getChar
           c <- getChar
           newline
           putChar c
           putChar b
           putChar a
           newline

> test2
abc
cba
```

Now lets write a function that prints *n* newlines in a row:

```haskell
multinewline :: Int -> IO ()
multinewline 1 = putChar '\n'
multinewline n = do putChar '\n'
                    multinewline (n-1)
```

Since the return type of `multinewline` is `IO ()` it is an action, and can be
used inside do-notation.

This lets us write:

```haskell
test3 = do a <- getChar
           b <- getChar
           c <- getChar
           multinewline 3
           putChar c
           putChar b
           putChar a
           multinewline 2

> test3
abc


cba

```

Next, let's write an action that uses `putChar` to print an entire string on the
screen.

```haskell
myPutStr :: String -> IO ()
myPutStr ""     = return ()  -- nothing to print
myPutStr (c:cs) = do putChar c
                     myPutStr cs
```

Let's look at each part:

- The input to `myPutStr` is a `String`, and the output is `IO ()`. `myPutStr`
  modifies the state of the world, but it doesn't return a value and so it has
  type `IO ()`.

- `myPutStr ""` prints nothing. Since `myPutStr ""` has the type `IO ()`, it
  evaluates to `return ()`. `return` has type `a -> IO a`, and converts an `a`
  value to an `IO a` value, and so `retrun ()` returns an `IO ()`.

- For a non-empty string `s`, `myPutStr s` prints the first character of `s`
  using `putChar`, and then prints the rest of the string (using recursion).

For convenience, we also define `myPutStrLn`, which adds a newline at the end of
the printed string:

```haskell
myPutStrLn :: String -> IO ()
myPutStrLn s = do myPutStr s
                  putChar '\n'  -- or use: newline

> myPutStrLn "hello"
hello
```

Finally, we can use `getChar` to create a version of `getLine`:

```haskell
myGetLine :: IO (String)
myGetLine = do c <- getChar
               if c == '\n' then
                  return ""
               else
                  do cs <- myGetLine
                     return (c:cs)
```

The `myGetLine` action doesn't take any input, it just returns an `IO (String)`.
When called, `myGetLine` checks if the first character read is a newline. If it
is, then `return ""`, which as type `IO String`, is returned. Otherwise, the
rest of the line is recursively read in, and the initial character is cons-ed
onto the start of that string.

Notice that we use do-notation in two separate cases. 

Now we can write "simple" programs like this:

```haskell
hello :: IO ()
hello = do myPutStr "Hi! What's your name? "
           name <- myGetLine
           myPutStrLn ("Hello " ++ name ++ ", how are you?")
```

```haskell  
> hello
Hi! What's your name? Alonzo
Hello Alonzo, how are you?
```

Or this:

```haskell
printBox :: String -> IO ()
printBox s = do myPutStr bar 
                myPutStrLn ("| " ++ s ++ " |")
                myPutStr bar
             where n   = length s
                   bar = "+" ++ (replicate (n+2) '-') ++ "+" ++ "\n"
```

```haskell
> printBox "Watch this space!"
+-------------------+
| Watch this space! |
+-------------------+
```

### Challenge: password checking

Write a function called `check` that asks the user to enter a password, and then
asks them to enter it again. If the two passwords match, print "Passwords
match!", otherwise print "Error: passwords don't match".

The characters typed by the user should be displayed as `*` characters (see the
`sgetLine` function in the textbook's Hangman example).

Here's a sample run:

```haskell
> check
Enter password: *********
Enter password again: *********
Passwords match!

> check
Enter password: *****
Enter password again: ****
Error: passwords don't match
```

As part of your answer, include the type signature for `check`. 

### Explain the bug: returning myGetLine directly

In your own words, explain the bug in this code, and how you would fix it (i.e.
re-write the code so it works):

```haskell
myGetLine :: IO (String)
myGetLine = do c <- getChar
               if c == '\n' then
                  return ""
               else
                  return (c:myGetLine)
```


## Example: Hangman
See text.

## Example: Nim
See text.

## Example: Life
See text.
