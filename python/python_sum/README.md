Among Python programmers, there is a rumor that list comprehensions are faster
than for-loops, while-loops, or recursion. Let's test this hypothesis by
answering this question:

   What is the sum of all the numbers in the file [numbers.txt](numbers.txt) ([zip](numbers.txt.zip))
   that are greater than, or equal to 1, and less than, or equal to 100?

Please work with your TA group, and answer this questions in the following ways:

1. Using a for-loop.
2. Using a while-loop.
3. Using a list comprehension (without the walrus operator).
4. Using a list comprehension (with the walrus operator).
5. Using recursion.

(Don't use AI to automatically write this. The purpose is for **you** to go
through the problem-solving process and understand the different implementation
methods.)

For each implementation, using the same [numbers.txt](numbers.txt) ([zip](numbers.txt.zip)) file as the
input, measure the total time it takes to read the file and print the final sum. Be wary of a couple of things:

- The different implementations should do the same work. If one implementation
  does extra work, then differences in times may be due to this extra work, and
  not the difference in the implementation method.

- You should run each function at least 10 times and take an average.

When you are done, share the results with your TA group, and also on this [class spreadsheet](https://docs.google.com/spreadsheets/d/1FkH9MDu9vOqdC8OwNAYydsVXyuO_Tyr5LtqQlMAzOKo/edit?usp=sharing).

What is your final conclusion? Are list comprehensions faster? Or is another
approach faster?
