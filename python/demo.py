# demo.py

# names = ['bob', '', 'mary', 'carla', 'sam', 'dean']

# result = []
# for n in names:
#     if n != '':
#         result.append(n.capitalize())
# print(result)

# result = [n.capitalize() 
#                          for n in names 
#                          if n != ''
#          ]
# print(result)

# A = [1, 2, 3, 4]
# B = 'a Bob c'.split() # ['a', 'b', 'c']

# # A cross product B
# result = []
# for x in A:
#     for y in B:
#         result.append((x, y))
# print(result)

# result = [(x, y) for x in A for y in B]
# print(result)

# result = [(x, y) for x in range(1, 101)
#                  for y in range(1, 101)
#                  if x < y
#         ]
# print(result)

# def get_score(s):
#     return sum(ord(c) for c in s)

# names = 'Dimitrious'.split()
# # walrus operator :=
# high_scores = [(n, score) for n in names if (score := get_score(n)) is not None
#                                          if score > 500]
# print(high_scores)
# print(score)

def my_zip(A, B):
    # return [(a, b) for a in A for b in B]
    assert len(A) == len(B)
    result = []
    for i in range(len(A)):
        result.append((A[i], B[i]))
    return result

# lst1 = [1, 2, 3, 4]
# lst2 = [5, 6, 7, 8]
#      [6, 8, 10, 12]
#      1*5 + 2*6 + 3*7 + 4*8
# for (x, y) in zip(lst1, lst2):
#     print(x + y)

# result = [x + y for x, y in zip(lst1, lst2)]
# result = sum(x*y for x, y in zip(lst1, lst2))
# print(result)

s = 'this is the biggest shoe I have ever eaten'
result = [(x, y) for x, y in zip(s, s[1:])]
print(result)
