# letters1_demo.py

#
# Iterators that return a finite value will crash. What should we do instead
# when it runs out of values?
#

class Letters:
    def __init__(self, s):
        self.s = s
        self.index = 0
    
    def next(self):
        self.index += 1
        return self.s[self.index - 1]  # crashes if there are no more letters!


letters = Letters("cat")
print(letters.next())
print(letters.next())
print(letters.next())
print(letters.next()) # crashes!
