# search.py

#
# Demonstrates passing a function to another function.
#

#
# Returns the index of the first item x in lst such that match_fn(lst) returns
# True.
#
# match_fn takes a single input and returns either True or False, i.e. it's a
# predicate function
#
def find(lst, match_fn):
    for i, x in enumerate(lst):
        if match_fn(x):
            return i
    return -1  # nothing found


def is_four(s):
    return len(s) == 4

# Returns True if s has two consecutive letters that are the same.
def has_repeat(s):
    n = len(s)
    if n < 2:
        return False
    else:
        for i in range(1, n):
            if s[i - 1] == s[i]:
                print(s[i - 1], s[i])
                return True
        return False

lst = ["Tina", "Gene", "Bob", "Louise", "Lynn"]

# recall that := is the walrus operator, which assigns the value of the
# expression to a variable so that it can be used in the statement
if (i := find(lst, is_four)) == -1:
    print("No four-letter words found")
else:
    print(f"First four-letter word found at index {i}: {lst[i]}")

if (i := find(lst, has_repeat)) == -1:
    print("No words with repeated letters found")
else:
    print(f"First word with repeated letters found at index {i}: {lst[i]}")
