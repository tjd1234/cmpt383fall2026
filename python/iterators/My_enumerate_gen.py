# My_enumerate_gen.py

def my_enumerate(lst):
    index = 0
    for item in lst:
        yield index, item
        index += 1

for i, v in my_enumerate(["a", "b", "c"]):
    print(i, v)
