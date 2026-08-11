# counter2.py

#
# Returns multiple closures that set, get, and increment a counter. The three
# closures share the same variable n. Similar to object-oriented programming!
# object-oriented programming.
#
def make_counter2():
    n = 0
    def set_n(x):
        nonlocal n
        n = x
    def get_n():
        nonlocal n
        return n
    def inc_n():
        nonlocal n
        n += 1
    return set_n, get_n, inc_n

set_n, get_n, inc_n = make_counter2()
print(get_n()) # 0
inc_n()
print(get_n()) # 1
inc_n()
print(get_n()) # 2
set_n(10)
print(get_n()) # 10
