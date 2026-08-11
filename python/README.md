# Advanced Python

## List comprehensions

### Basic concepts

**List comprehensions** are a concise and efficient way to create lists. They
are based on mathematical set notation. For example, the set of the squares of
the numbers 1 to 5 is $\\{x^2 : x \in \\{1, 2, 3, 4, 5 \\} \\}$. In Python we
can write:

```python
>>> [x**2 for x in [1, 2, 3, 4, 5]]
[1, 4, 9, 16, 25]
```

Or:

```python
>>> [x**2 for x in range(1, 6)]
[1, 4, 9, 16, 25]
```

It's that same as writing:

```python
>>> squares = []
>>> for x in [1, 2, 3, 4, 5]:
...     squares.append(x**2)
...
>>> squares
[1, 4, 9, 16, 25]
```

You can also add a condition to filter out elements. For example, if you just
want the even numbers from 1 to 5, you can write:

```python
>>> [x for x in range(1, 6) if x % 2 == 0]
[2, 4]
```

This is the same as:

```python
>>> even_numbers = []
>>> for x in range(1, 6):
...     if x % 2 == 0:
...         even_numbers.append(x)
...
>>> even_numbers
[2, 4]
```

Here are the squares of the even numbers from 1 to 10:

```python
>>> [x**2 for x in range(1, 11) if x % 2 == 0]
[4, 16, 36, 64, 100]
```

If you use more than one if clause they are and-ed together. This returns all
non-empty strings that have an even number of characters:

```python
>>> [s.title() for s in ['bob', '', 'mary', 'carla', 'sam', 'dean'] if s.strip() != '' if len(s) % 2 == 0]
['Mary', 'Dean']
```

Or formatted a little differently:

```python
>>> [s.title() for s in ['bob', '', 'mary', 'carla', 'sam', 'dean'] 
               if s.strip() != '' 
               if len(s) % 2 == 0]
['Mary', 'Dean']
```

### Multiple clauses

If a comprehension has more than one `for` clause they act like nested `for`
loops. For example, here are all the pairs of numbers from 1 to 3:

```python
>>> [(x, y) for x in range(1, 4) for y in range(1, 4)]
[(1, 1), (1, 2), (1, 3), (2, 1), (2, 2), (2, 3), (3, 1), (3, 2), (3, 3)]
```

It's often formatted like this:

```python
>>> [(x, y) for x in range(1, 4) 
            for y in range(1, 4)]
[(1, 1), (1, 2), (1, 3), (2, 1), (2, 2), (2, 3), (3, 1), (3, 2), (3, 3)]
```

It's the same as writing:

```python
>>> pairs = []
>>> for x in range(1, 4):
...     for y in range(1, 4):
...         pairs.append((x, y))
...
>>> pairs
[(1, 1), (1, 2), (1, 3), (2, 1), (2, 2), (2, 3), (3, 1), (3, 2), (3, 3)]
```

We can also use if clauses with multiple for clauses. For instance, what are
the solutions to the equation $x^2 + y = 100$ for $x$ and $y$ integers between 1
and 100? We can write:

```python
>>> [(x, y) for x in range(1, 101) 
            for y in range(1, 101) 
            if x**2 + y == 50]
[(1, 49), (2, 46), (3, 41), (4, 34), (5, 25), (6, 14), (7, 1)]
```

This is the same as writing:

```python
>>> solutions = []
>>> for x in range(1, 101):
...     for y in range(1, 101):
...         if x**2 + y == 50:
...             solutions.append((x, y))
...
>>> solutions
[(1, 49), (2, 46), (3, 41), (4, 34), (5, 25), (6, 14), (7, 1)]
```

This is an example of **brute force**, or **exhaustive** enumeration: we
generate and test all possible solutions. Since the ranges are not too large,
it's feasible in this case. But if the ranges were larger, it would take too
long to run.

### Cartesian products

If $A$ and $B$ are two sets, then their **Cartesian product $A \times B$** is
the set of all pairs $(a, b)$ where $a \in A$ and $b \in B$, i.e. $A \times B =
\\{ (a, b) : a \in A, b \in B \\}$. In Python:

```python
>>> [(a, b) for a in A 
            for b in B]
```

If $A$ has $m$ elements and $B$ has $n$ elements, then $A \times B$ has $mn$
elements. If $m=n$, then $A \times B$ has $n^2$ elements, and so the
comprehension makes $n^2$ elements, which is a quadratic run time.

Generalizing this, the Cartesian product of the sets $A_1, A_2, \ldots, A_n$ is
the set of all $n$-tuples $(a_1, a_2, \ldots, a_n)$ where $a_i \in A_i$ for $i =
1, 2, \ldots, n$, i.e. $A_1 \times A_2 \times \cdots \times A_n = \\{ (a_1, a_2,
\ldots, a_n) : a_i \in A_i \\}$ for $i = 1, 2, \ldots, n$. 

In Python:

```python
[(a1, a2, ..., an) for a1 in A1 
                   for a2 in A2 
                   ... 
                   for an in An]
```

`...` is not valid Python code, and is just a placeholder.

This is the same as writing $n$ nested `for` loops:

```python
values = []
for a1 in A1:
    for a2 in A2:
        ...
        for an in An:
            values.append((a1, a2, ..., an))

print(values)
```

If $A_1, \ldots, A_n$ all have $m$ elements, then $A_1 \times A_2 \times \cdots
\times A_n$ has $m \cdot m \cdot \ldots \cdot m = m^n$ elements, and so the
comprehension makes $m^n$ elements, a running time which is exponential in $n$.
For example, if all the sets are $0, 1$, then the comprehension makes $2^n$
elements, and contains all the bit strings of length $n$.

For instance, here are all $2^3=8$ bit sequences of length 3:

```python
>>> [(a, b, c) for a in [0,1] 
               for b in [0,1] 
               for c in [0,1]]
[(0, 0, 0), (0, 0, 1), (0, 1, 0), (0, 1, 1), 
 (1, 0, 0), (1, 0, 1), (1, 1, 0), (1, 1, 1)]
```

If you treat the sequences as binary numbers, then this has generated the
numbers 0 to 7 in binary:

```
000 = 0
001 = 1
010 = 2
011 = 3
100 = 4
101 = 5
110 = 6
111 = 7
```

Thinking of list comprehensions as Cartesian products is a nice connection to
mathematics, It lets us use ideas from math to help reason about our code (and
vice versa).

**Example**. See [abc_puzzle.py](abc_puzzle.py) for a more detailed example.

### The walrus operator

Consider this function:

```python
def get_score(s): 
    return sum(ord(c) for c in s)
```

It returns the sum of the [ASCII values](https://en.wikipedia.org/wiki/ASCII) of
the characters in the string, e.g. `get_score('cat')` returns 312. A function
like this might be useful with a hash table of strings.

Now consider this code, which gets a list of all the names and scores that match
a certain condition:

```python
all_names = ['Bob', 'Alice', 'Charlie', 'Bev']

high_scores = [(n, get_score(n))
               for n in all_names 
               if get_score(n) % 5 != 0
              ]
```

For each name, `get_score` is called *twice*, and it returns that same result
each time. That's inefficient. We can do better by using the **walrus
operator**, `:=`, to save the value of the result in a variable:

```python
high_scores = [(n, score)
               for n in all_names 
               if (score := get_score(n)) % 5 != 0  # walrus operator used here
              ]
```

The first time `get_score` is called its result is saved in the variable `score`
using `:=`. Then `score` can be used in other parts of the comprehension without
calling `get_score` again.

In some situations the walrus operator can make code more concise and efficient,
so be on the lookout for situations where it can be used.

[high_scores.py](high_scores.py) contains the complete code example.

### Using zip

A sometimes useful function is `zip`, which takes two (or more) lists and gives
a list of pairs (or tuples) of the corresponding elements. For example:

```python
>>> lst1 = [1, 2, 3]
>>> lst2 = ['a', 'b', 'c']
>>> for x, y in zip(lst1, lst2):
...     print(x, y)
...
1 a
2 b
3 c
>>> list(zip(lst1, lst2))
[(1, 'a'), (2, 'b'), (3, 'c')]
```

We'll assume that the lists we pass to `zip` are the same length.

We can use `zip` to add two lists of numbers element-wise:

```python
>>> lst1 = [1, 2, 3]
>>> lst2 = [4, 5, 6]
>>> total = [x + y for x, y in zip(lst1, lst2)]
>>> total
[5, 7, 9]
```

Note that using two for loops *doesn't* do the same thing:

```python
>>> [x + y for x in lst1 
           for y in lst2]
[5, 6, 7, 6, 7, 8, 7, 8, 9]
```

That's the sums of all pairs of elements in the Cartesian product of the lists.

Using this trick you can compute the **dot product** of two lists of numbers
like this:

```python
>>> lst1 = [1, 2, 3]
>>> lst2 = [4, 5, 6]
>>> dot_product = sum([x * y for x, y in zip(lst1, lst2)])
>>> dot_product
32
```

In this case, the []-brackets are not needed:

```python
>>> sum(x * y for x, y in zip(lst1, lst2))
32
```

While this is a short and simple way to calculate the dot product, it's not the
most efficient way. For fast dot products in Python you should use a
special-purpose library, like `numpy`.

#### Pairing Related Pieces of Information

Here's another example where `zip` pairs-up related pieces of information. This
calculates the names of the students who passed an exam:

```python
names = ["Alice", "Bob", "Charlie"]
scores = [85, 40, 92]

passing = [name for name, score in zip(names, scores) 
                if score > 50]

print(passing) # ['Alice', 'Charlie']
```

#### Pairs of Adjacent Elements

`zip` can help you get pairs of adjacent elements in a sequence. For example:

```python
>>> s = 'house'
>>> adj_pairs = [(x, y) for x, y in zip(s, s[1:])]
>>> adj_pairs
[('h', 'o'), ('o', 'u'), ('u', 's'), ('s', 'e')]
```

`s[1:]` is the string `'ouse'`, so the zip expression is the same as
`zip('house', 'ouse')`. The strings are different lengths, and so `zip` stops
after pairing up the first four characters.

Using this trick you can write the `is_sorted` function like this:

```python
>>> def is_sorted(lst):
...     return all(x <= y for x, y in zip(lst, lst[1:]))
...
>>> is_sorted([1, 2, 3, 4, 5])
True
>>> is_sorted([1, 3, 2, 4, 5])
False
```

`all` is a built-in function that returns `True` if all the elements of the
expression generating the list are `True`, and `False` otherwise.

This is not the most efficient way to write the `is_sorted` function, but it's
short enough to fit on one line.

#### The Unpacking Operator

As another example of unpacking (as shown above), consider this function which
takes three arguments:

```python
def f(a, b, c):
    return a + b + c
```

We can call it like this:

```python
print(f(1, 2, 3)) # 6
```

But suppose we have list of values:

```python
values = [1, 2, 3]
print(f(values)) # error: wrong number of arguments
```

`f` takes three arguments, the expression `f(values)` only passed one argument.
We could fix it like this:

```python
print(f(values[0], values[1], values[2])) # 6
```

That works, but it's a pain to write. The unpacking operator `*` lets us do the
same thing more concisely:

```python
print(f(*values)) # 6
```

#### Transposing a Matrix

Finally, consider **transposing** a matrix (a fundamental operation in linear
algebra). For example if you have the matrix:

```
1 2
3 4
5 6
```

It's transpose is:

```
1 3 5
2 4 6
```

Transposing swaps the rows and columns.

In Python the first matrix would be:

```python
[[1, 2],  # row 0
 [3, 4],  # row 1
 [5, 6]]  # row 2
```

And the transpose would be:

```python
[[1, 3, 5],  # column 0
 [2, 4, 6]]  # column 1
```

Can you how `zip` and the `*` unpacking operator to transpose the matrix?

Using `zip` and the `*` operator we can transpose a matrix like this:

```python
matrix = [[1, 2], [3, 4], [5, 6]]
transposed = [list(row) for row in zip(*matrix)]
```

The expression `zip(*matrix)` is, in this example, the same as `zip([1, 2], [3,
4], [5, 6])`. The `*` operator *unpacks* the elements of `matrix` into its
individual lists and passes them to `zip` as separate arguments (`zip` can take
any number of lists). `zip([1, 2], [3, 4], [5, 6])` yields these values:

```python
>>> for row in zip([1, 2], [3, 4], [5, 6]):
...     print(row)
...
(1, 3, 5)
(2, 4, 6)
```

`(1, 3, 5)` holds the firsts elements of each list, and `(2, 4, 6)` holds the
second elements. After converting the tuples to lists, you get the transpose of
the matrix!

See [zip_demo_sol.py](zip_demo_sol.py) for a more complete code example.

## Generators and Co-routines

### Enumerate

It's common in Python to want both the indices and values of the elements of a
list. You can get those like this:

```python
>>> lst = ['a', 'b', 'c']
>>> for i in range(len(lst)):
...     print(i, lst[i])
...
0 a
1 b
2 c
```

This is a common enough operation that Python provides a built-in function,
`enumerate`, that does this for you:

```python
>>> for i, value in enumerate(lst):
...     print(i, value)
...
0 a
1 b
2 c
```

This is a little shorter and more readable than the first version.

You could use it to find the smallest element in a list and its index:

```python
def get_min(lst):
    """Returns the smallest element and its index in lst.
    """
    min_value = lst[0]
    min_index = 0
    for i, value in enumerate(lst):
        if value < min_value:
            min_value = value
            min_index = i
    return min_value, min_index

print(get_min([3, 2, 4, 1, 5])) # (1, 3)
```

### Iterators

In general, an **iterator** is an object that returns values. In practice, it is
often used to give sequential access to a collection of objects. A Python
iterator is essentially an object that has "next" method that you call to get the
next element from the iterator. 

Let's build our own iterator as an example (we'll see shortly how to make it an
official Python iterator):

```python
class Counter:
    def __init__(self):
        self.value = 0
    
    def next(self):
        self.value += 1
        return self.value
```

This stores a single integer value, and has a `next` method that increments the
value and returns it. We can use it like this:

```python
counter = Counter()
print(counter.next()) # 1
print(counter.next()) # 2
print(counter.next()) # 3
```

Here's an iterator that iterates over the letters of a given string `s`:

```python
class Letters:
    def __init__(self, s):
        self.s = s
        self.index = 0
    
    def next(self):
        self.index += 1
        return self.s[self.index - 1]  # crashes if there are no more letters!
```

To use it:

```python
letters = Letters("cat")
print(letters.next()) # 'c'
print(letters.next()) # 'a'
print(letters.next()) # 't'
print(letters.next()) # crashes!
```

`Letters` is useful as long as there are more letters to iterate over. But when
all the letters have returned, it crashes. And crashing is never a good thing! 

Note that `Counter` *doesn't* crash: it has no end. `Counter` is an example of
an **endless iterator**, or an **infinite iterator**.

To deal with iterators that are done (i.e. have no more elements to return),
Python uses the `StopIteration` exception. The idea is that if `next` is called
when the iterator is done, it raises a `StopIteration` exception. We can modify
`Letters` like this:

```python
class Letters:
    def __init__(self, s):
        self.s = s
        self.index = 0
    
    def next(self):
        if self.index < len(self.s):
            self.index += 1
            return self.s[self.index - 1]
        else:
            raise StopIteration
```

The:

```python
letters = Letters("cat")
print(letters.next()) # 'c'
print(letters.next()) # 'a'
print(letters.next()) # 't'
print(letters.next()) # StopIteration exception
```

It still crashes, but now we know that it will raise `StopIteration`.

### Making Iterators with `__iter__` and `__next__`

Python has built-in support for iterators called the **iterator protocol**. An
Python object is an iterator if it conforms to the iterator protocol. That means
it must have these two methods:

- `__next__()` returns the next value from the iterator, and raises
`StopIteration` if there are no more values. Python calls it `__next__` instead
of `next` since it is a Python convention to use double underscores for special
methods.

- `__iter__()` returns the iterator object itself. This usually just returns
`self`, i.e. the object itself. But container objects, such as a list, have
`__iter__` so that you can get an iterator object for the container.

The idea is that calling `__iter__()` gets you an iterator object that is
guaranteed to have a `__next__` method. 

So lets update `Letters` to make it an official Python iterator:

```python
class Letters:
    def __init__(self, s):
        self.s = s
        self.index = 0
    
    def __iter__(self):
        return self
    
    def __next__(self):
        if self.index < len(self.s):
            self.index += 1
            return self.s[self.index - 1]
        else:
            raise StopIteration
```

We can still use this as before, using the  `__next__` method:

```python
letters = Letters("cat")
print(letters.__next__()) # 'c'
print(letters.__next__()) # 'a'
print(letters.__next__()) # 't'
print(letters.__next__()) # StopIteration exception
```

But now we can also use the `next` function, which is a little more readable:

```python
letters = Letters("cat")
print(next(letters)) # 'c'
print(next(letters)) # 'a'
print(next(letters)) # 't'
print(next(letters)) # StopIteration exception
```

And we can use it in a `for` loop:

```python
letters = Letters("cat")
for c in letters:
    print(c)
```

Or:

```python
for c in Letters("cat"):
    print(c)
```

This for-loop is pretty nice: it's short, readable, and doesn't require any
knowledge of the iterator protocol. The for-loop takes care of the messy
details.

Python already provides an iterator like `Letters` for strings. We can iterate
directly over strings like this:

```python
for c in "cat":
    print(c)
```

This works because Python strings implement the `__iter__` method, which returns
an iterator object that has a `__next__` method. Strings themselves are *not*
iterators, but you can always get an iterator object for them by calling
`__iter__`. For example:

```python
it = iter("cat")
for c in it:
    print(c)
```

But as we've seen, we can just write this:

```python
for c in "cat":
    print(c)
```

This shows us something important: `for` works with an object that has
`__iter__` method. When the for-loop runs, it calls `__iter__` to get an
iterator object, and then calls `__next__` on that iterator object to get the
values.

In Python terminology, we say that strings are **iterable** (but they are *not*
iterators). In general, any object that has an `__iter__` method is iterable. An
iterator is any object that is both iterable (has an `__iter__` method) *and*
has a `__next__` method.

### Our Own enumerate

Let's make a version of the `enumerate` iterator that works with lists:

```python
class My_enumerate:
    def __init__(self, lst):
        self.lst = lst
        self.index = 0
    
    def __iter__(self):
        return self
    
    def __next__(self):
        if self.index < len(self.lst):
            i = self.index
            value = self.lst[i]
            self.index += 1
            return i, value
        else:
            raise StopIteration
```

With iterators, it is standard for `__iter__` to return `self` because it is
already an iterator.

We can use it like this:

```python
for i, v in My_enumerate(["a", "b", "c"]):
    print(i, v)

# 0 a
# 1 b
# 2 c
```

### Our Own reverse

Python has a built-in iterator called `reversed` that iterates over a sequence
in reverse order:

```python
for i in reversed([1, 2, 3, 4]):
    print(i)

# 4
# 3
# 2
# 1
```

Let's make our own version of `reversed`:

```python
class My_reversed:
    def __init__(self, lst):
        self.lst = lst
        self.index = len(lst) - 1
    
    def __iter__(self):
        return self
    
    def __next__(self):
        if self.index >= 0:
            self.index -= 1
            return self.lst[self.index + 1]
        else:
            raise StopIteration
```

The index is initialized to the last item of the list, and decremented each time
`__next__` is called.

So:

```python
for i in My_reversed([1, 2, 3, 4]):
    print(i)

# 4
# 3
# 2
# 1
```

### An Iterator for Primes

Let's make a more complex iterator, one that generates prime numbers. We want it
to work like this:

```python
primes = Primes()
for p in range(5):
    print(next(primes))

# 2
# 3
# 5
# 7
# 11
```

To implement it, we first write couple of helper functions for finding primes:

```python
def is_prime(n):
    """Returns True if n is a prime number, False otherwise."""
    if n < 2:
        return False
    for d in range(2, n):
        if n % d == 0:
            return False
    return True

def next_prime(n):
    """Returns the next prime number after n."""
    while True:
        n += 1
        if is_prime(n):
            return n
```

`next_prime` is curious because it appears to contain an infinite loop, but we
know it does *not* run forever thanks to [Euclid's
theorem](https://en.wikipedia.org/wiki/Euclid's_theorem) (which proves there are
infinitely many primes).

Now we can implement `Primes`:

```python
class Primes:
    def __init__(self):
        self.value = 1
    
    def __iter__(self):
        return self
    
    def __next__(self):
        self.value = next_prime(self.value)
        return self.value
```

The source code for `Primes` is relatively simple thanks to our helper
functions. Calling`__next__` calls `next_prime`, which could do a lot of work:
for large values of `n`, it could take a long time to find the next prime
number.

Let's write a related iterator that generates the primes less than a given
number. We'll use the `Primes` iterator, and stop when we reach the given
number:

```python
class Primes_less_than:
    def __init__(self, max):
        self.max = max
        self.primes = Primes()
    
    def __iter__(self):
        return self
    
    def __next__(self):
        p = next(self.primes)
        if p < self.max:
            return p
        else:
            raise StopIteration
```

This lets us write:

```python
for p in Primes_less_than(10):
    print(p)

# 2
# 3
# 5
# 7
```

Or we can write a function that returns all the primes less than a given number:

```python
def primes_less_than(n):
    return [p for p in Primes_less_than(n)]

print(primes_less_than(10)) # [2, 3, 5, 7]
```

Experience shows that iterators are a powerful tool for writing code that is
concise, readable, and easy to reason about. But implementing `__next__`
requires writing classes that store the state of the iterator, and in practice
that can be difficult to do correctly.

So Python provides a more convenient way to write iterators: **generators**.

### Making Generators with `yield`

Suppose we want an iterator to iterate over the strings "Step A", "Step B", and
"Step C". We could write a class like this:

```python
class SimpleSteps:
    def __init__(self):
        self.steps = ["Step A", "Step B", "Step C"]
        self.index = 0
    
    def __iter__(self):
        return self

    def __next__(self):
        if self.index < len(self.steps):
            self.index += 1
            return self.steps[self.index - 1]
        else:
            raise StopIteration

for step in SimpleSteps():
    print(step)

# Step A
# Step B
# Step C
```

This works, but it's a pain to write: most of the code is boilerplate that makes
it hard to see the important parts.

So instead Python lets us write a **generator function** that returns an
iterator:

```python
def simple_steps():
    yield "Step A"
    yield "Step B"
    yield "Step C"

for step in simple_steps():
    print(step)

# Step A
# Step B
# Step C
```

You could also use it like this:

```python
gen = simple_steps()
print(next(gen)) # Step A
print(next(gen)) # Step B
print(next(gen)) # Step C
print(next(gen)) # StopIteration exception
```

This is much nicer: it's shorter, simpler, and more readable.

`simple_steps` is an example of a **generator function**. A generator function
is a function that returns a **generator object**, which is a special kind of
iterator. Like all iterators, generator objects have an `__iter__` and
`__next__` method, but they also remember the values of variables and let you
use `yield` to return them.

`yield` is like `return`, but instead of returning a value and ending the
function, it returns a value and then remembers what line of code it is on and
the values of variables. When `__next__` is called, the function continues from
the line after the last `yield`.

Let's write another version of `enumerate` (for lists), but this time using a
generator function:

```python
def my_enumerate(lst):
    index = 0
    for item in lst:
        yield index, item
        index += 1

for i, v in my_enumerate(["a", "b", "c"]):
    print(i, v)

# 0 a
# 1 b
# 2 c
```

Compared to `My_enumerate`, this is shorter and more readable.

We can write our own version of `reversed` like this:

```python
def my_reversed(lst):
    index = len(lst) - 1
    while index >= 0:
        yield lst[index]
        index -= 1

for i in my_reversed([1, 2, 3, 4]):
    print(i)

# 4
# 3
# 2
# 1
```

Prime numbers can be generated like this:

```python
def primes_gen():
    """Yields all the prime numbers."""
    n = 2
    while True:
        yield n
        n = next_prime(n)

primes = primes_gen()
print(next(primes)) # 2
print(next(primes)) # 3
print(next(primes)) # 5
```

We add `_gen` to the name to indicate that it is a generator function. This is
an infinite generator, since it never stops yielding prime numbers.

Again, compared to the classes above that do the same thing, generator functions
are generally simpler and more readable.

## Closures and decorators

### Closures

A **closure** is an object that acts like a function, but also has an
environment of variables that persist after the function returns. When you write
a function that returns a function, you are (usually) creating a closure.

For example, consider this code:

```python
def make_adder(n):
    def adder(x):
        return x + n
    return adder

add3 = make_adder(3)
print(add3(4)) # 7

add5 = make_adder(5)
print(add5(4)) # 9

print(add3(add5(2))) # 10
```

`make_adder(n)` returns a closure that adds `n` to its argument. This
interesting because the variable `n` is not local to `adder`, and is not passed
as a parameter. Yet, when `adder` is called, it can use the value of `n` that
was passed to `make_adder`. Python makes this work by storing the value of `n`
in an environment with the function, and together, the function and its
environment, form a closure.

Here's another example. `make_counter` returns a function that returns the
number of times it has been called:

```python
def make_counter():
    n = 0
    def counter():
        nonlocal n
        n += 1
        return n
    return counter

counter = make_counter()
print(counter()) # 1
print(counter()) # 2
print(counter()) # 3
```

The situation is a bit different here. The variable `n` is being *modified* by
the `counter` function. In this case, Python requires that `n` be marked as
`nonlocal` so that Python knows to use the variable from the enclosing scope.

Generalizing this, here is a function that returns three closures that set, get,
and increment a counter. All three closures share the same variable `n`:

```python
def make_counter2():
    n = 0
    def set_n(x):
        nonlocal n
        n = x
    def get_n():
        nonlocal n
        return n
    def increment():
        nonlocal n
        n += 1
    return set_n, get_n, increment

set_n, get_n, increment = make_counter2()
print(get_n()) # 0
increment()
print(get_n()) # 1
increment()
print(get_n()) # 2
set_n(10)
print(get_n()) # 10
```

### Basic Decorators

A common programming pattern that closures help with is wrapping a function
inside another function to give it some extra behavior. For example, suppose we
have this function to simulate doing laundry:

```python
def do_laundry():
    import time
    print("Doing laundry ... ")
    time.sleep(1)
    print("Laundry done")
```

Now suppose we want to time exactly how long it takes to run. We could modify it
like this:

```python
def do_laundry():
    import time
    start_time = time.time()
    print("Doing laundry ... ")
    time.sleep(1)
    print("Laundry done")
    end_time = time.time()
    print(f"Time taken: {end_time - start_time} seconds")

do_laundry()
# Doing laundry ... 
# Laundry done
# Time taken: 1.0050978660583496 seconds
```

This works, but it's messy, and the timing code is not reusable. So instead,
lets write a function that can take `do_laundry` as input and return a new
function that times it:

```python
def make_timed_function(f):
    def timed_function():
        import time
        start_time = time.time()
        result = f()
        end_time = time.time()
        print(f"Time taken: {end_time - start_time} seconds")
        return result
    return timed_function

timed_do_laundry = make_timed_function(do_laundry)
timed_do_laundry()
# Doing laundry ... 
# Laundry done
# Time taken: 1.000473976135254 seconds
```

This is a much nicer way to do it. The function `make_timed_function` takes any
function `f` --- that has no parameters --- and returns a new function that
calls `f` and also prints the time it took to execute `f`. The user of
`make_timed_function` doesn't need to know the details of how to time the
function.

This is done commonly enough that Python provides a special syntax for it:

```python
@make_timed_function
def do_laundry():
    import time
    print("Doing laundry ... ")
    time.sleep(1)
    print("Laundry done")

timed_do_laundry()
# Doing laundry ... 
# Laundry done
# Time taken: 1.005068063735962 seconds
```

`@make_timed_function` is a **decorator**. It does the same thing
`timed_do_laundry = make_timed_function(do_laundry)`, but keeping the same name
`do_laundry`:

Here's another example:

```python
def make_hello_goodbye(f):
    def hello_goodbye():
        print(f'{f.__name__} called ...')
        result = f()
        print(f'... {f.__name__} done')
        return result
    return hello_goodbye

@make_hello_goodbye
def do_laundry():
    print("Doing laundry ... ")
    time.sleep(1)
    print("Laundry done")

do_laundry()
# do_laundry called ...
# Doing laundry ... 
# ... do_laundry done
```

You can give multiple decorators to a function:

```python
@make_hello_goodbye
@make_timed_function
def do_laundry():
    print("Doing laundry ... ")
    time.sleep(1)
    print("Laundry done")

do_laundry()

# timed_function called ...
# Doing laundry ... 
# Laundry done
# Time taken: 1.0002081394195557 seconds
# ... timed_function done
```

Notice that the name of the function is `timed_function`, not `do_laundry`.
That's because first `make_timed_function` is applied, and then
`make_hello_goodbye` to the result.

### Decorating Functions with Parameters

The decorators we've seen so far all take a function as input, and, importantly,
that function has no parameters. What if we want to decorate a function that
does have parameters? It's not immediately obvious how to do this.

Let's add some parameters to `do_laundry`:

```python
def do_laundry(who, duration):
    import time
    print(f"{who} is doing laundry ... ")
    time.sleep(duration)
    print(f"{who}'s laundry is done")
```

We *can't* use the `make_timed_function` decorator we wrote earlier because it
assumes that the function being decorated has no parameters. We could modify it
to work with this version, which takes two parameters, but better would be a
general solution that works with any number of parameters.

The trick to handling parameters in Python is to use `*args` and `**kwargs` to
capture the positional and keyword arguments. This works with any number of
parameters:

```python
def make_timed_function(f):
    def timed_function(*args, **kwargs):
        start_time = time.time()
        result = f(*args, **kwargs)
        end_time = time.time()
        print(f"Time taken: {end_time - start_time} seconds")
        return result
    return timed_function

@make_timed_function
def do_laundry(who, duration):
    import time
    print(f"{who} is doing laundry ... ")
    time.sleep(duration)
    print(f"{who}'s laundry is done")

do_laundry("Alice", 1.2)
# Alice is doing laundry ... 
# Alice's laundry is done
# Time taken: 1.2012641429901123 seconds
```

Look at the header for `timed_function`:

```python
def timed_function(*args, **kwargs)
```

`*args` in a function header is Python's way of capturing 0 or more **positional
arguments**. Positional arguments are passed in the order they are given, e.g.
in `do_laundry("Alice", 1.2)`, `"Alice"` is the first argument and so get's
assigned to `who`, and `1.2` is the second argument and so gets assigned to
`duration`.

`**kwargs` in a function header is Python's way of capturing 0 or more **keyword
arguments**. Keyword arguments are passed as `key=value` pairs, e.g. we could
call `do_laundry(duration=1.2, who="Alice")`, and 1.2 gets assigned to
`duration` and "Alice" gets assigned to `who`.

If a function uses both positional and keyword arguments, the positional
arguments must come first, followed by the keyword arguments. So, to get all
kinds of arguments, we write `def timed_function(*args, **kwargs)`.

We can use this version of `make_timed_function` to decorate any function, e.g.:

```python
@make_timed_function
def hello_world():
    print("Hello, world!")

hello_world()
# Hello, world!
# Time taken: 1.1205673217773438e-05 seconds
```

If you decorate a recursive function, then each recursive call is decorated. For
example:

```python
@make_timed_function
def factorial(n):
    if n == 0:
        return 1
    return n * factorial(n - 1)

print(factorial(5))

# Time taken: 1.1920928955078125e-06 seconds
# Time taken: 1.5974044799804688e-05 seconds
# Time taken: 2.002716064453125e-05 seconds
# Time taken: 2.2172927856445312e-05 seconds
# Time taken: 2.384185791015625e-05 seconds
# Time taken: 2.5987625122070312e-05 seconds
# 120
```

If you only want to print the time for the outermost call, then you can use
another helper function:

```python
def _factorial(n):
    if n == 0:
        return 1
    return n * _factorial(n - 1)

@make_timed_function
def factorial(n):
    return _factorial(n)

print(factorial(5))

# Time taken: 2.1457672119140625e-06 seconds
# 120
```

[This video](https://www.youtube.com/watch?v=3tyaO-OE0K0) gives a similar
explanation of decorators.

## Context Managers

Python context managers are a way to manage resources in a clean and safe way.
They are used to allocate and de-allocate resources such as files, sockets, and
locks.

A context manager is an object that has `__enter__` and `__exit__` methods. They
work with the `with` statement. For example:

```python
with open('file.txt') as f:
    for line in f:
        print(line)
```

In this code, the file is opened when the `with` statement is entered, and when
the loop exits, the file is closed. The context manager automatically takes care
of the opening and closing of the file.

Lets write out own context manager to show the basic idea. Consider the `Greet`
class:

```python
class Greet:
    def __init__(self, name):
        self.name = name

    def __enter__(self):
        print(f"Hello, {self.name}!")

    def __exit__(self, exc_type, exc_val, exc_tb):
        print(f"Goodbye, {self.name}!")
```

We can use it like this:

```
with Greet("Alice"):
    print("How are you?")
```

It prints:

```
Hello, Alice!
How are you?
Goodbye, Alice!
```

You can replaced `__enter__` and `__exit__` with whatever you want to do. For
example, we could use it to start and stop a timer:

```python
with Timer() as t:
    time.sleep(1)
    print("Done")
```

This prints the time taken to run the block of code:

```
Done
Elapsed: 0.101 seconds
```

Here is the `Timer` class:

```python
import time

class Timer:
    def __enter__(self):
        """Called when entering the 'with' block. Return value becomes the 'as' variable.
        """
        self.start = time.perf_counter()
        return self  # so you could do "with Timer() as t: ... t.start"

    def __exit__(self, exc_type, exc_val, exc_tb):
        """Called when leaving the block (normal exit or exception).
        """
        elapsed = time.perf_counter() - self.start
        print(f"Elapsed: {elapsed:.3f} seconds")
        return False  # False = don't suppress any exception; re-raise if one occurred
```

The parameters to `__exit__` are used for handling exceptions that might occur
in the block of code:

- `exc_type`: the type of the exception that occurred, or `None` if no exception
  occurred

- `exc_val`: the value of the exception that occurred, or `None` if no exception
  occurred

- `exc_tb`: the traceback of the exception that occurred, or `None` if no
  exception occurred

## The Match Statement

The `match` statement is a new feature in Python 3.10. It is a more powerful
alternative to the `if` statement, and is somewhat similar to the `switch`
statement in C/C++, but more flexible. 

Essentially, a `match` statement compares a value to a sequence of patterns,
stopping at the pattern that matches. It can also automatically extract parts of
some values.

```python
def http_error(status):
    match status:
        case 400:
            return "Bad request"
        case 404:
            return "Not found"
        case 418:
            return "I'm a teapot"
        case _:
            return "Something's wrong with the internet"

print(http_error(400))  # Bad request
print(http_error(404))  # Not found
print(http_error(418))  # I'm a teapot
print(http_error(500))  # Something's wrong with the internet
```

The cases are checked in the order they are written. `_` is a catch-all that
matches anything, and so often the last case is `case _`.

You can use `|` as "or" to match multiple patterns at once. For example:

```python
def http_error(status):
    match status:
        case 400:
            return "Bad request"
        case 401 | 403 | 404:  # 401, 403, and 404 are grouped together
            return "Not allowed"
        case 404:
            return "Not found"
        case 418:
            return "I'm a teapot"
        case _:
            return "Something's wrong with the internet"
```

This example uses variables to extract parts of the value being matched:

```python
def print_point(point):
    match point:
        case (0, 0):
            print("Origin")
        case (0, y):
            print(f"On the y-axis at {y}")
        case (x, 0):
            print(f"On the x-axis at {x}")
        case (x, y):
            print(f"X={x}, Y={y}")
        case _:
            raise ValueError("Not a point")

print_point((0, 0)) # Origin
print_point((0, 3)) # On the y-axis at 3
print_point((6, 0)) # On the x-axis at 6
print_point((2, 5)) # X=1, Y=1
print_point([6, 4]) # X=6, Y=4
print_point((6, 4, 2)) # Not a point
```

It's often useful to match a list and extract the first element and the rest of
the list. For example:

```python
def print_parts(lst):
    match lst:
        case [first, *rest]:
            print(first)
            print(rest)
        case _:
            print(f'Cannot match {lst}')

print_parts([1, 2, 3]) 
# 1 
# [2, 3]
                       
print_parts(['up', 'down', 'left', 'right']) 
# up 
# ['down', 'left', 'right']

print_parts([5])
# 5
# []

print_parts([]) 
# Cannot match []
```

Here's how we could get the min using `match`:

```python
def get_min(lst):
    match lst:
        case []:
            raise ValueError("List is empty")
        case [x]:
            return x
        case [first, *rest]:
            min_rest = get_min(rest)
            return first if first < min_rest else min_rest

print(get_min([3])) # 3
print(get_min([3, 4])) # 3
print(get_min([4, 3])) # 3
print(get_min([3, 3])) # 3
print(get_min([3, 4, 5])) # 3
```

A few things to note:
- It's a recursive function.
- It's clearly states that the empty list, `[]`, raises an error.
- It's also clear that the min of a list with a single element is just the
  element itself.
- The third case is binds the first element of the list to `first`, and the rest
  of the list to `rest`. Then it finds the min of the rest of the list and
  compares it to the first element.

Python's `match` doesn't always work as you might like. For example:

```python
def bad_contains(x, lst):
    match lst:
        case []:
            return False
        case [x, *_]:
            return True
        case [_ , *rest]:
            return bad_contains(x, rest)

print(bad_contains(3, [])) # False
print(bad_contains(3, [4])) # True  <--- not what we want!
print(bad_contains(3, [3])) # True 
```

In `bad_contains`, one might think that the second `case` matches just if the
first element of the list is equal to `x`. For example, if `lst` is `[4, 5, 6]`
and `x` is 3, then you might think that this *does not* match because 4 is not
equal to 3.

But that's not how it works in Python. Instead, the second `case` binds the
first element of the list to `x`, over-writing the `x` passed in as an argument.
In other words, `x` is set to be the first element of `lst`, whatever it is. And
so `True` is returned for any list of one or more elements.

To implement it correctly you would need to do something like this:

```python
def good_contains(x, lst):
    match lst:
        case []:
            return False
        case [first, *rest]:
            return first == x or good_contains(x, rest)

print(good_contains(3, [])) # False
print(good_contains(3, [4])) # False
print(good_contains(3, [3])) # True
```
