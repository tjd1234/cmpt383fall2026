# iterators_sol.py

def test_enumerate():
    print("Testing enumerate:")
    lst = ['cookie', 'pie', 'cupcake', 'cake']
    for i, value in enumerate(lst):
        print(i, value)

test_enumerate()

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

def test_my_enumerate():
    print("Testing My_enumerate:")
    lst = ['cookie', 'pie', 'cupcake', 'cake']
    for i, value in My_enumerate(lst):
        print(i, value)

test_my_enumerate()
