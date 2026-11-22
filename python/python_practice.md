The Fibonacci sequence goes 0, 1, 1, 2, 3, 5, 8, 13, ... (it starts with 0 and
1, and each subsequent number is the sum of the previous two). Generate it in
the following ways:

1. Using a class that implements the Python **iterator protocol** with
   `__next__` and `__iter__`.  Demonstrate that it works by writing a function
   that uses your iterator with a for-loop to print the first N numbers in the
   sequence.

2. Using a **generator function**.  Demonstrate that it works by writing a
   function that uses it with a for-loop to print the first N numbers in the
   sequence.

The next question is not about the Fibonacci sequence:

3. Write a **decorator** that works for *any* Python function and prints the
   function name and the parameters it was called with, and then an ending
   message after the function returns that includes its return value.

   Test this on a recursive Fibonacci function (not one of the previous
   iterator/generator ones!). Be careful: we only want to see the input/output
   of the first function call, not every recursive call.
