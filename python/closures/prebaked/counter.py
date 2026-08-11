# counter.py

# In this example, variable n is local to make_counter. When make_counter ends,
# n is destroyed. But the returned counter function needs n to stick around to
# be incremented. When a variable is modified like this, Python requires that
# the variable be marked as nonlocal.
def make_counter():
    n = 0
    def counter():
        nonlocal n
        n += 1
        return n
    return counter

counter1 = make_counter()
print('counter1: ', counter1()) # 1
print('counter1: ', counter1()) # 2
print('counter1: ', counter1()) # 3

counter2 = make_counter()
print('counter2: ', counter2()) # 1
print('counter2: ', counter2()) # 2
print('counter2: ', counter2()) # 3

print('counter1: ', counter1()) # 4
