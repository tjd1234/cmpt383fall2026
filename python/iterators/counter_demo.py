# counter_demo.py

#
# Intuitively, an iterator is an object that has a next() method. Every time you
# call next() you get another element from the iterator.
#

class Counter:
    def __init__(self):
        self.value = 0

    def next(self):
        self.value += 1
        return self.value

counter = Counter()
print('counter first 2 values:')
print(counter.next())
print(counter.next())

print('counter next 5 values:')
for i in range(5):
    print(counter.next())
