# My_reversed_gen.py

def my_reversed(lst):
    index = len(lst) - 1
    while index >= 0:
        yield lst[index]
        index -= 1

for i in my_reversed([1, 2, 3, 4]):
    print(i)
