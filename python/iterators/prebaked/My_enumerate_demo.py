# My_enumerate_demo.py

#
# This is a version of the built-in enumerate iterator.
#

class My_enumerate:
    def __init__(self, lst):
        self.lst = lst
        self.index = 0
    
    def __iter__(self):
        return self
    
    def __next__(self):
        if self.index < len(self.lst):
            i = self.index
            value = self.lst[i]
            self.index += 1
            return i, value
        else:
            raise StopIteration

pets = ['cat', 'dog', 'bird']
for i, pet in My_enumerate(pets):
    print(i, pet)
