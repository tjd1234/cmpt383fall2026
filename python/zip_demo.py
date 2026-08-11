# zip_demo.py

def zip_tricks():
    A = [1, 2, 3, 4]
    B = [5, 6, 7, 8]
    C = [9, 10, 11, 12]

    result = [[a, b]
                for a, b in zip(A, B)
    ]
    # for a, b, c in zip(A, B, C):
    #     result.append([a, b, c])
    print(result)

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
        print(*row)
        # for val in row:
        #     print(f'{val} ', end='')
        # print()

def matrix_demo():
    print_matrix(m1)
    print()
    print_matrix(m2)

# matrix_demo()


#
# How could we use zip to transpose a matrix?
#
# The zip_tricks function shows an answer for a matrix with known dimensions.
#

# m2 = [
#     [1, 2, 3], # A
#     [4, 5, 6], # B
#     [7, 8, 9]  # C
# ]
# assumes matrix is 3 rows, 3 columns
def transpose3(matrix):
    result = []
    for a, b, c in zip(matrix[0], matrix[1], matrix[2]):
        result.append([a, b, c])
    return result

# print_matrix(m1)
# print()
# print_matrix(transpose3(m1))

# m1 = [
#     [1, 2],
#     [3, 4],
#     [5, 6],
#     [7, 8]
# ]

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

# def like_demo():
#     like(1, 2, 3)
#     nums = [4, 5, 6]
#     # like(nums[0], nums[1], nums[2])
#     like(*nums) # * is the unpacking operator
#     print(nums)
#     print(*nums) # print(4, 5, 6)
    # ...

# like_demo()

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

def transpose(matrix):
    return [list(row) for row in zip(*matrix)]
    # result = []
    # for row in zip(*matrix):
    #     result.append(row)
    # return result

def transpose_demo():
    print_matrix(m1)
    print()
    print(transpose(m1))

    print()
    print()

    print_matrix(m2)
    print()
    print_matrix(transpose(m2))

transpose_demo()
