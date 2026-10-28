# letters2_demo.py

#
# In Python, the standard way to deal with iterators that are done is to raise a
# StopIteration exception as shown here.
#
# An uncaught exception will crash the program. But you can catch it and handle
# it gracefully.
#

class Letters:
    def __init__(self, s):
        self.s = s
        self.index = 0
    
    def next(self):
        if self.index < len(self.s):
            self.index += 1
            return self.s[self.index - 1]
        else:
            raise StopIteration

letters = Letters("cat")
print(letters.next())
print(letters.next())
print(letters.next())
print(letters.next()) # StopIteration exception
