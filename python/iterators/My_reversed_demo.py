# My_reversed_demo.py

#
# This is a version of the built-in reversed iterator.
#

# class My_reversed:
#     def __init__(self, lst):
#         self.lst = lst
#         self.index = len(lst) - 1
    
#     def __iter__(self):
#         return self
    
#     def __next__(self):
#         if self.index >= 0:
#             self.index -= 1
#             return self.lst[self.index + 1]
#         else:
#             raise StopIteration

def My_reversed(lst):
    index = len(lst) - 1
    while index >= 0:
        yield lst[index]
        index -= 1

nums = [1, 2, 3, 4]
print(f'nums: {nums}')
for i in My_reversed(nums):
    print(i)

print([i for i in My_reversed(nums)])
