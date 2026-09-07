# Python Problem Set

The questions on the Python quiz will mainly be variations of the questions
below, or questions that are similar.

Questions may be updated or added as the course progresses.

Please post your answers to the discussion board to share with other students.

**Important**: *Treat these problem-sets as non-AI activities!* Turn off all AI
support and try to figure them out yourself. Having AI or another student do
this for you will not help you learn. You must do the learning yourself!

## Question 1

In your own words, explain to a beginning CMPT 120 student what a **list
comprehension** is in Python. How is it related to mathematical set notation?

## Question 2

Write list comprehensions to do the following:

- Make a list of all the numbers from 1 to 100 that are multiples of 5, e.g.
  `[5, 10, 15, ...]`.

- Remove from a given list all the strings of even length.

- Remove from a given list all the 0s, *add* 1 to all negative numbers, and
  *subtract* 1 from all positive numbers. For instance, `[0, 2, -2, 0, -3]`
  becomes `[1, -1, -2]`.

- Make a list of all 4-bit tuples, e.g. `[(0,0,0,0), (0, 0, 0, 1), (0, 0, 1, 0), ...]`.

- Given three lists, generate all 3-tuples of `(a, b, c)` where `a` is from the
  first list, `b` is from the second list, `c` is from the third list, and `a`,
  `b`, and `c` are all different.

- Make a list of all integer solutions to the equation `a^2 + b^2 = c^2`. Assume
  `a`, `b`, and `c` are all integers between 1 and 100, and `a < b < c`. Write
  each solution as a tuple `(a, b, c)`. The list starts and ends with: `[(3, 4,
  5), (5, 12, 13), (6, 8, 10), ..., (60, 80, 100), (65, 72, 97)]`.

## Question 3

In Python, what is the **walrus operator**? What is used for? Give an example.

## Question 4

a) Write a function called `my_zip2(A, B)` that takes two lists, `A` and `B`, of
the same size. It should return a list of tuples just like `zip`.

b) Using `my_zip2` and `sum`, show how to calculate the **dot product** of two
lists of numbers. Assume the lists are non-empty, only contain numbers, and have
the same length.

For example, the dot product of `[1, 2, 3]` and `[4, 5, 6]` is `1*4 + 2*5 + 3*6
= 32`.

c) Write a function called `my_zip(L1, L2, ..., Ln)` that takes $n \geq 2$ lists
(all the same size) as input and returns a list of tuples just like `zip`. If
$n$ is less than 2, then raise a `ValueError`.

d) Using `my_zip`, write a function called `add_lists(L1, L2, ..., Ln)` that
adds lists `L1` to `Ln` element-wise. You can assume they are all the same size
(and non-empty), and all list of numbers.

For example, `add_lists([1, 2, 3], [4, 5, 6], [1, 1, 1])` should return `[6, 8, 10]`.

## Question 5

Write a function called `make_numbered_list(lst)` that takes a list of strings
and returns a string that is formatted as a numbered list as shown.

Make a few variations of this function, at least:

- One that uses a loop (and `enumerate`).

- One that uses list comprehensions (and `enumerate`).

- One whose body is as short as possible (i.e. a single `return` statement).


For example:

```
result = make_numbered_list(['apple', 'banana', 'cherry'])
print(result)
```

Should print:

```
1. apple
2. banana
3. cherry
```

## Question 6

Write a function called `get_max(lst)` that uses `enumerate` to return the
largest value in the list. Assume the list is non-empty and is either all
numbers or all strings.

For example, `get_max([4, 8, 4, 1])` should return 8, and `get_max(['soap',
'cat', 'dog'])` should return `'soap'`.

## Question 7

In your own words, explain Python's **iterator protocol**. What are the methods
required? What happens when there is no more data to iterate over?

## Question 8

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

## Question 9

In your own words, explain to another programmer what it means that Python
strings are **iterable** but not **iterators**.

## Question 10

Using the **iterator protocol**, write your own class version of `enumerate`
called `My_enumerate` that works with lists.

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

## Question 11

Write a **generator function** (using `yield`) to make your own version of each
of these built-in functions:

- `my_range_gen(a, b)` works the same as `range(a, b)`, i.e. it generates the
  numbers from `a`, `a + 1`, `a + 2`, ..., `b - 1`.
  
- `my_zip2_gen(A, B)` works the same as `zip(A, B)`, i.e. it generates the pairs
  of elements from `A` and `B`. You can assume `A` and `B` are lists of the same
  length, there are only two lists.

## Question 12

Write a generator function (using `yield`) called `longer_than_gen(n, lst)` that
generates all the strings in `lst` that are longer than `n`. For example:

```python
pets = ['cat', 'hamster','dog', 'bird']
for s in longer_than_gen(3, pets):
    print(s)
```

Should print:

```
hamster
bird
```

## Question 13

Write a generator function (using `yield`) called `lines_of_file_gen(filename)`
that generates the line number and the line of a text file one at a time. For
example, suppose the file `joke.txt` contains the following text:

```
Who's there?
A broken pencil.
A broken pencil who?
Never mind. It's pointless.
```

Then:

```python
for i, line in lines_of_file_gen('joke.txt'):
    print(f'{i + 1}: {line}')
```

Should print:

```
1: Who's there?
2: A broken pencil.
3: A broken pencil who?
4: Never mind. It's pointless.
```

## Question 14

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

## Question 15

In your own words, explain to another programmer what a Python **decorator** is.
Give an example of how to use one.

## Question 16

Write a Python decorator called `always_return_str` that ensures a function
always returns its results as a string.

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

## Question 17

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

## Question 18

Write a function called `classify_grade(score)` that uses the `match` statement
that returns as string grade for the given score (as shown below). You can
assume `score` is an integer between 0 and 100. 

The grades are:

- A for scores 90 or higher
- B for scores 80 to 89
- C for scores 70 to 79
- D for scores 50 to 69
- F for scores 0 to 49

For example:

```python
print(classify_grade(95))   # A
print(classify_grade(80))   # B
print(classify_grade(79))   # C
print(classify_grade(62))   # D
print(classify_grade(48))   # F
```

## Question 19

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
