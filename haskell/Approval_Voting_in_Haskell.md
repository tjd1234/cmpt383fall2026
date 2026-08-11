## Overview of Approval Voting

In [approval voting](https://en.wikipedia.org/wiki/Approval_voting), a voters
fill in ballots that look like this:

```
Ballot 1: A, B, D
Ballot 2: B
Ballot 3: B, D, B
Ballot 4: none
Ballot 5: A, B, C, D
```

Each voter casts one ballot, and the ballot is a *subset* the candidates they
*approve* of.

For example, Ballot 1 approves of candidates A, B, and D (and so disapproves of
candidate C). Ballot 4 disapproves of *all* the candidates, and they choose no
one. At the other extreme is Ballot 5, which approves of all candidates.

As with any set, the order of candidates doesn't matter, and duplicates are
ignored. On Ballot 3, for example, candidate B appears twice. You can't vote for
a candidate more than once, and so the extra B is removed: B, D, B becomes B, D.
 
To determine the winner of an approval vote we count which candidate appears
most on all the ballots (making sure to first remove any duplicates on a
ballot). In the example above, the final counts are:

```
A: 2
B: 4
C: 1
D: 3
```

The winner is B, with 4 votes.

## Representing Ballots

To do approval voting in Haskell, lets first think about how to represent a
single ballot. Assuming the candidates can be represented by a single character,
each ballot can be a list of characters, i.e. a string:

```
Ballot 1: A, B, D
        "ABD"

Ballot 2: B
        "B"

Ballot 3: B, D, B
        "BDB"

Ballot 4: none
        ""

Ballot 5: A, B, C, D
        "ABCD"
```

The ballots could then be stored as a list:

```haskell
["ABD", "B", "BDB", "", "ABCD"]
```

This is a convenient input format for a Haskell function, and so it's what we'll
use. Will refer to this list as the `ballots`.

## The Top-level Organization

Now lets think about how to process `ballots` to get the correct counts. The
general steps seem to be:

- Remove duplicates from each individual ballot, and then combine them into one
  big string.
- Get a list of the candidates in the election, e.g. A, B, C, and D are the
  candidates in the example above. We can determine the candidates by removing
  duplicates from the big string in the previous step.
- For each candidate, count how many times they appear in the big string.
- Return the final result as a list of (candidate, count) pairs, sorted in order
  from most votes to least:
  ```haskell
  [('B',4),('D',3),('A',2),('C',1)]
  ```

## Helper Functions

This seems like a reasonable overall strategy. One of the thing's we'll need is
a function that removes duplicate values from a list, so we can use this:

```haskell
removeDups :: Eq a => [a] -> [a]
removeDups []     = []
removeDups (x:xs) = if x `elem` xs 
                    then removeDups xs
                    else x : removeDups xs
```

**Alternate Implementation** `removeDups` could also be implemented with
`foldr`:

```haskell
removeDups :: Eq a => [a] -> [a]
removeDups lst = foldr (\x acc -> if elem x acc
                                  then acc
                                  else x : acc)
                       [] lst
```


If you don't write the argument `lst`, the function is in **point-free style**:

```haskell
removeDups :: Eq a => [a] -> [a]
removeDups = foldr (\x acc -> if elem x acc
                              then acc
                              else x : acc
                   ) []
```

We'll also need a sorting function. We could use insertion sort:

```haskell
insert :: Ord a => a -> [a] -> [a]
insert a [] = [a]
insert a (x:xs) | a <= x    = a:x:xs
                | otherwise = x : (insert a xs)

-- insertion sort
sort :: Ord a => [a] -> [a]
sort []     = []
sort (x:xs) = insert x (sort xs)
```

Or we could import the standard Haskell `sort` function by putting this line at
the top of the program:

```haskell
import Data.List
```

This makes all the functions (which includes `sort`) in `Data.List` available in
the program.

Suppose ballots is the name of the list `["ABD", "B", "BDB", "", "ABCD"]`. How
can we remove duplicates from individual ballots? We can do that with `map
removeDups ballots`:

```haskell
> ballots = ["ABD", "B", "BDB", "", "ABCD"]
> map removeDups ballots
["ABD","B","DB","","ABCD"]
```

Next, how do we create one big string of all the ballot strings combined? The
standard `concat` functions does exactly that:

```haskell
> concat (map removeDups ballots)
"ABDBDBABCD"
```

To get the list of candidates, we just remove all the duplicates in the big
string of candidates:

```haskell
> removeDups (concat (map removeDups ballots))
"ABCD"
```

We can now count the number of votes that each candidate received:

```haskell
> [(count c allVotes, c) | c<-candidates]
[(2,'A'),(4,'B'),(1,'C'),(3,'D')]
```

`count` is this function:

```haskell
count :: Eq a => a -> [a] -> Int
count v xs = length (filter (==v) xs)
```

The implementation idea of `count` is to remove all values in `xs` *not* equal
to `v`, and so what remains are all the values equal to `v`. The length of this
list is the number of times `v` occurs in `xs`.

**Alternate Implementation** `count` could also be implemented with `foldr`:

```haskell
count :: Eq a => a -> [a] -> Int
count v xs = foldr (\x acc -> acc + if x == v
                                    then 1
                                    else 0)
                   0 xs
```

You could also delete `xs` to get a **point-free style** version:

```haskell
count :: Eq a => a -> [a] -> Int
count v = foldr (\x acc -> acc + if x == v
                                 then 1
                                 else 0)
                0
```

The 0 sitting alone in space isn't great for readability, so you can do this:

```haskell

count :: Eq a => a -> [a] -> Int
count v = foldr op 0
where op = \x acc -> acc + if x == v
                           then 1
                           else 0
```

We're almost done. Two more steps are needed. The first is to sort the pairs
from biggest to smallest:

```haskell
> reverse (sort [(2,'A'),(4,'B'),(1,'C'),(3,'D')])
[(4,'B'),(3,'D'),(2,'A'),(1,'C')]
```

Finally, the candidate name should appear first in each pair, and so we swap the
order of the pairs:

```haskell
> map (\(x,y) -> (y,x)) [(2,'A'),(4,'B'),(1,'C'),(3,'D')]
[('B',4),('D',3),('A',2),('C',1)]
```

## The Final Function
After working through this example, we encode our solution as a function:

```haskell
approvalCount :: [String] -> [(Char, Int)]
approvalCount ballots = map (\(x,y) -> (y,x)) results
                        where 
                           allVotes   = concat (map removeDups ballots)
                           candidates = removeDups allVotes
                           rawCounts  = [(count c allVotes, c) | c<-candidates]
                           results    = reverse (sort rawCounts)
```

Now `approvalCount` gives us the results of the election:

```haskell
> approvalCount ballots1
[('B',4),('D',3),('A',2),('C',1)]
```

The first element on the list tells is that `B` is the winner with 4 votes.
