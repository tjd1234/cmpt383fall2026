# comprehensions.py

# TODO 1 Write a program that sets the variable named result to be the list [1,
# 2, 3, 4, 5]. Use a loop to add the numbers.
result = []
for i in range(1, 6):
    result.append(i)

print('TODO 1:', result) # [1, 2, 3, 4, 5]

# TODO 2 Write a program that sets the variable named result to be the list [1,
# 2, 3, 4, 5]. Use a list comprehension to add the numbers.
result = [x for x in range(1, 6)]
print('TODO 2:', result) # [1, 2, 3, 4, 5]

# TODO 3 Write a program that sets the variable named result to be the list [1,
# 4, 9, 16, 25], i.e. the squares of the numbers 1 to 5. Use a loop to add the
# squares of the numbers.
result = []
for i in range(1, 6):
    result.append(i ** 2)
print('TODO 3:', result) # [1, 4, 9, 16, 25]

# TODO 4 Re-do the previous question using a list comprehension.
result = [x**2 for x in range(1, 6)]
print('TODO 4:', result) # [1, 4, 9, 16, 25]

# TODO 5 Write a program that uses a loop to set the variable named result to be
# just the odd numbers from 1 to 10.
result = []
for i in range(1, 10 + 1):
    if i % 2 == 1:
        result.append(i)
print('TODO 5:', result) # 

# TODO 6 Re-do the previous question using a list comprehension.
result = [x for x in range(1, 11) if x % 2 == 1]
print('TODO 6:', result) # [1, 3, 5, 7, 9]

# TODO 7 Write a program that uses a loop to set the variable named result to be
# just the squares of the odd numbers from 1 to 10.

# ...
# print('TODO 7:', result) # [1, 9, 25, 49, 81]

# TODO 8 Re-do the previous question using a list comprehension.
result = [x**2 for x in range(1, 11) if x % 2 == 1]
print('TODO 8:', result) # [1, 9, 25, 49, 81]

# TODO 9 Using a list comprehension, make a list of all the non-empty strings in
# names, and capitalize them.
names = ['bob', '', 'mary', 'carla', 'sam', 'dean']
result = [n.capitalize() for n in names 
                         if n != ''
         ]
print('TODO 9:', result) # ['Bob', 'Mary', 'Carla', 'Sam', 'Dean']

# TODO 10 Re-do the previous question, but this time print the list as a nicely
# formatted comma-separated string, e.g. "Bob, Mary, Carla, Sam, Dean".
names = ['bob', '', 'mary', 'carla', 'sam', 'dean']
result = [n.capitalize() for n in names if n != '']
print('TODO 10:', ', '.join(result)) # 'Bob, Mary, Carla, Sam, Dean'
