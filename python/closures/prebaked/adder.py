# adder.py

# Returns a closure (a function with an environment of variables) f such that
# f(x) returns x + n. The closure can be called like a regular function.
def make_adder(n):
    def adder(x):
        return x + n
    return adder

add3 = make_adder(3)
print(add3(4))

add5 = make_adder(5)
print(add5(2))

print(add3(add5(2)))
