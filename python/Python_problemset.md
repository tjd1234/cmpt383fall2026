# Python Problem Set

The questions on the Python quiz will mainly be variations of the questions
below, or questions that are similar.

Please post your answers to the discussion board to share with other students.

**Important**: *Treat these problem-sets as non-AI activities!* Turn off all AI
support and try to figure them out yourself. Having AI or another student do
this for you will not help you learn. You must do the learning yourself!

## Question 1

In your own words, explain to a beginning CMPT 120 studentwhat a **list
comprehension** is in Python.

## Question 2

Write list comprehensions to do the following:

- Make a list of all the numbers from 1 to 100 that are multiples of 5, e.g.
  `[5, 10, 15, ...]`.

- Remove from a given list all the strings of even length.

- Remove from a given list all the 0s, *add* 1 to all negative numbers, and
  *subtract* 1 from all positive numbers. For instance, `[0, 2, -2, 0, -3]`
  becomes `[1, -1, -2]`.

- Make a list of all 4-bit tuples, e.g. `[(0,0,0,0), (0, 0, 0, 1), (0, 0, 1, 0), ...]`.

- Given three list, generate all 3-tuples of `(a, b, c)` where `a` is from the
  first list, `b` is from the second list, `c` is from the third list, and `a`,
  `b`, and `c` are all different.

- Make a list of all integer solutions to the equation `a^2 + b^2 = c^2`. Assume
  `a`, `b`, and `c` are all integers between 1 and 100, and `a < b < c`. Write
  each solution as a tuple `(a, b, c)`. The list starts and ends with: `[(3, 4,
  5), (5, 12, 13), (6, 8, 10), ..., (60, 80, 100), (65, 72, 97)]`.

## Question 3

In Python, what is the **walrus operator**? What is used for? Give an example.

## Question 4

Write your own version of Python's `zip` function called `my_zip`. It should
take two lists and return a list of tuples, where each tuple is a pair of
elements from the two lists.

For example, `my_zip([1, 2, 3], [4, 5, 6])` should return `[(1, 4), (2, 5), (3,
6)]`.

Using the `my_zip` function, write a function called `add_lists(A, B)` that that
adds two lists of numbers element-wise. Assume the lists are non-empty, only
contain numbers, and have the same length.

For example, `add_lists([1, 2, 3], [4, 5, 6])` should return `[5, 7, 9]`.

## Question 5

Using `zip` and `sum`, show how to calculate the **dot product** of two lists of
numbers. Assume the lists are non-empty, only contain numbers, and have the same
length.

For example, the dot product of `[1, 2, 3]` and `[4, 5, 6]` is `1*4 + 2*5 + 3*6
= 32`.

## Question 6

Given a list of strings, use a loop (or a list comprehension) and `enumerate` to
print each string on its own line, numbered starting from 1. 

For example, if the list is `['apple', 'banana', 'cherry']`, the output should
be:

```
1. apple
2. banana
3. cherry
```

## Question 7

Write a function called `get_max(lst)` that uses `enumerate` to return the
largest value in the list. Assume the list is non-empty and is either all
numbers or all strings.

For example, `get_max([4, 8, 4, 1])` should return 8, and `get_max(['soap',
'cat', 'dog'])` should return `'soap'`.

## Question 8

In your own words, explain the **iterator protocol** in Python. What are the
methods required? What happens when there is no more data to iterate over?

## Question 9

Using the **iterator protocol**, write an iterator class that iterates over the
letters of a given string in *reverse* order.

For example:

```python
for c in My_reversed('cat'):
    print(c)
```

should output:

```
t
a
c
```

## Question 10

In your own words, explain to another a programmer what it means that Python
strings are **iterable** but not **iterators**.

## Question 11

Using the **iterator protocol**, write your own class version of `enumerate`
called `My_enumerate` that works with lists like the built-in `enumerate`.

For example:

```python
for i, v in My_enumerate(['a', 'b', 'c']):
    print(i, v)
```

should output:

```
0 a
1 b
2 c
```

## Question 12

Write a generator function (using `yield`) to make your own version of each of
these built-in functions:

- `my_range(a, b)` works the same as `range(a, b)`, i.e. it generates the
  numbers from `a`, `a + 1`, `a + 2`, ..., `b - 1`.
  
- `my_zip(A, B)` works the same as `zip(A, B)`, i.e. it generates the pairs of
  elements from `A` and `B`. You can assume `A` and `B` are lists of the same
  length, there are only two lists.

## Question 13

Write a generator function (using `yield`) called `gen_longer_than(n, lst)` that
generates all the strings in `lst` that are longer than `n`. For example:

```python
pets = ['cat', 'hamster','dog', 'bird']
for s in gen_longer_than(3, pets):
    print(s)
```

Should print:

```
hamster
bird
```

## Question 14

Write a generator function (using `yield`) called `gen_lines_of(filename)` that
generates the line number and the line of a text file one at a time. For
example, suppose the file `joke.txt` contains the following text:

```
Who's there?
A broken pencil.
A broken pencil who?
Never mind. It's pointless.
```

Then:

```python
for i, line in gen_line_of('joke.txt'):
    print(f'{i + 1}: {line}')
```

Should print:

```
1: Who's there?
2: A broken pencil.
3: A broken pencil who?
4: Never mind. It's pointless.
```

## Question 15

Write a function called `make_bounds_checker(min, max)` that returns a
**closure** that checks if a given value is greater than or equal to `min` and
less than or equal to `max`.

For example:

```python
good_score = make_bounds_checker(0, 100)
print(good_score(50)) # True
print(good_score(101)) # False

is_teen = make_bounds_checker(13, 19)
print(is_teen(15)) # True
print(is_teen(12)) # False
print(is_teen(20)) # False
```

## Question 16

In your own words, explain to another programmer what a **decorator** is in
Python. Give an example of how to use one.

## Question 17

Write a Python decorator called `always_return_str` that makes a sure a function
always returns by calling `str` on its result.

For example:

```python
@always_return_str
def f(n):
    if n == 1:
        return 'one'
    elif n == 2:
        return 2
    elif n == 3:
        return [1, 2, 3]
    else:
        return ''

# isinstance(x, str) returns True if x is a string, and False
# otherwise
print(f(1), isinstance(f(1), str))
print(f(2), isinstance(f(2), str))
print(f(3), isinstance(f(3), str))
print(f(4), isinstance(f(4), str))
```

Prints:

```
one True
2 True
[1, 2, 3] True
 True
```

## Question 18

Write a context manager called `LoggedTimer` that measures the time taken to run
a block of code and logs the results in a file. It should work like this:

```python
with LoggedTimer('timer.log') as t:
    t.log("Starting sleep ...   ")
    time.sleep(1)
    t.log("Done sleeping!")

print('Done!')
```

When run this is printed on the console:

```
Logged to timer.log
Done!
```

The file `timer.log` contains:

```
Started at 3817326.148478291
Starting sleep ...   
Done sleeping!
Stopped at 3817327.1535275
Elapsed: 1.005 seconds
```

In the context manager, use the `__init__` method to store the filename.

## Question 19

Write a function called `classify_grade(score)` that uses the `match` statement
to print the grade for the given score (as shown below). You can assume `score`
is an integer between 0 and 100. 

The grades are:

- A for scores 90 or higher
- B for scores 80 to 89
- C for scores 70 to 79
- D for scores 50 to 69
- F for scores 0 to 49

For example:

```python
print(classify_grade(95))   # 95 is an A
print(classify_grade(80))   # 80 is a B
print(classify_grade(79))   # 79 is a C
print(classify_grade(62))   # 62 is a D
print(classify_grade(48))   # 48 is a F
```

## Question 20

Write a function called `calculate_area(shape)` that uses `match` to calculate
and return (not print!) the area of a given shape. You can assume the shape is
one of the following:

- `circle` with radius `r`
- `rectangle` with width `w` and height `h`
- `triangle` with base `b` and height `h`
- `square` with side length `s`

`shape` is a tuple whose first element is the shape type and the remaining
elements are the shape's parameters.

For example:

```python
print(calculate_area(("circle", 5)))       # 78.539...
print(calculate_area(("rectangle", 4, 6))) # 24
print(calculate_area(("triangle", 3, 8)))  # 12.0
print(calculate_area(("square", 7)))       # 49
print(calculate_area(("hexagon", 4)))      # Unknown shape
```
