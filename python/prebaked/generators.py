# generators_sol.py

# yield means this is a generator
def simple_steps():
    print('How to Wash Your Hair')
    print('---------------------')
    yield 'Step 1: open bottle'
    yield 'Step 2: squeeze shampoo into hand'
    yield 'Step 3: vigorously rub shampoo into hair'
    yield 'Step 4: wait, no: before step 3 wet your hair first'
    yield 'Step 5: rinse shampoo out of hair'
    # done

def test_simple_steps1():
    print("Testing simple_steps1:")
    # gen = simple_steps()
    for s in simple_steps():
        print(s)


test_simple_steps1()








# def test_simple_steps2():
#     print("Testing simple_steps2:")
#     for value in simple_steps():
#         print(value)

# test_simple_steps2()

def my_enumerate(lst):
    index = 0
    for item in lst:
        yield index, item
        index += 1

def test_my_enumerate():
    print("Testing my_enumerate:")
    lst = ['cookie', 'pie', 'cupcake', 'cake']
    for i, v in my_enumerate(lst):
        print(i, v)

test_my_enumerate()