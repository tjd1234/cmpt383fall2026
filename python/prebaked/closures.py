# closures.py

def make_counter2():
    n = 0
    def set_n(x):
        nonlocal n
        n = x
    def get_n():
        nonlocal n
        return n
    def increment():
        nonlocal n
        n += 1
    return set_n, get_n, increment

set_n, get_n, increment = make_counter2()
print(get_n()) # 0
increment()
print(get_n()) # 1
set_n(10)
print(get_n()) # 10
increment()
print(get_n()) # 11