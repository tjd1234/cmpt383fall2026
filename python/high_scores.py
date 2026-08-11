# high_scores.py

def get_score(s): 
    return sum(ord(c) for c in s)

all_names = ['Bob', 'Alice', 'Charlie', 'Bev']

#
# get_score(n) is called three times for each name, which is inefficient
#
high_scores = [(n, get_score(n))
               for n in all_names 
               if get_score(n) % 5 != 0
              ]
print(high_scores)

#
# By using := (the walrus operator) we can save the result in a variable and
# only call get_score once for each name.
#
high_scores = [(n, score)
               for n in all_names 
               if (score := get_score(n)) % 5 != 0
              ]
print(high_scores)
