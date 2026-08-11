# letters3_demo.py

#
# To make iterators in Python you should follow the **iterator protocol**. That
# means you should have two methods: __iter__ and __next__:
#
# - __next__ returns the next value from the iterator, raises StopIteration if
#   there are no more values.
#
# - __iter__ returns the iterator object itself. This usually just returns self,
#   i.e. the object itself. But container objects, such as a lists and strings,
#   have __iter__ so that you can get an iterator object for the container.
#
# for-loops work with objects that have __iter__ because they call __iter__ to
# get an iterator object, and then call __next__ on that iterator object to get
# the next values. When StopIteration is raised, the for-loop stops gracefully.
#

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

# letters = Letters("cat")
# print(letters.__next__())
# print(letters.__next__())
# print(letters.__next__())
# print(letters.__next__()) # StopIteration exception

letters = Letters("dog")
for c in letters:
    print(c)