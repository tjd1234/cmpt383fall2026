# my_enum.py

# class My_enumerate:
#     def __init__(self, lst):
#         self.lst = lst
#         self.index = 0
    
#     def __iter__(self):
#         return self
    
#     def __next__(self):
#         if self.index < len(self.lst):
#             self.index += 1
#             return self.index - 1, self.lst[self.index - 1]
#         else:
#             raise StopIteration

def My_enumerate(lst):
    index = 0
    for item in lst:
        yield index, item
        index += 1

pets = 'dog cat bird'.split()
print(pets)
print()

for i, p in enumerate(pets):
    print(i, p)

print()
for i, p in My_enumerate(pets):
    print(i, p)
