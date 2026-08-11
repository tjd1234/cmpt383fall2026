# letters.py

class Letters:
    def __init__(self, s):
        self.s = s
        self.index = 0
    
    def __iter__(self):
        return self
    
    def __next__(self):
        if self.index < len(self.s):
            self.index += 1
            return self.s[self.index - 1]
        else:
            raise StopIteration


for i, c in Letters('cat'):
    print(i, c)
