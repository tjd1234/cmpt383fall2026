# zip_demo.py

#
# zip tricks
#
def zip_tricks():
    A = [1, 2, 3, 4]
    B = [5, 6, 7, 8]
    C = [9, 10, 11, 12]

    for (a, b) in zip(A, B):
        print(a, b)

    print()

    for (a, b, c) in zip(A, B, C):
        print(a, b, c)

# zip_tricks()

#
# matrices
#
m1 = [
    [1, 2],
    [3, 4],
    [5, 6],
    [7, 8]
]

m2 = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9]
]

def print_matrix(matrix):
    for row in matrix:
        for val in row:
            print(f'{val} ', end='')
        print()

def matrix_demo():
    print_matrix(m1)
    print()
    print_matrix(m2)

#
# How could we use zip to transpose a matrix?
#
# The zip_tricks function shows an answer for a matrix with known dimensions.
#

# assumes matrix is 3 rows, 3 columns
def transpose3(matrix):
    return [[a, b, c] 
            for a, b, c in zip(matrix[0], matrix[1], matrix[2])
           ]
    # result = []
    # for a, b, c in zip(matrix[0], matrix[1], matrix[2]):
    #     result.append([a, b, c])
    # return result

#
# Try replacing m2 by m1 in the following code: you'll see that transpose chops
# off some of the result!
#
# print_matrix(m2)
# print()
# print_matrix(transpose3(m2))

#
# Dealing with multiple function arguments.
#
def like(a, b, c):
    print(f'I like {a}, {b}, and {c}.')

def like_demo():
    like(1, 2, 3)
    nums = [4, 5, 6]
    like(nums[0], nums[1], nums[2])
    like(*nums) # * unpacks nums to be parameters for like

# like_demo()

#
# Transposing any matrix with zip
#
def transpose(matrix):
    return [list(nums) 
            for nums in zip(*matrix)
           ]

print_matrix(m1)
print()
print_matrix(transpose(m1))

print()
print()

print_matrix(m2)
print()
print_matrix(transpose(m2))
