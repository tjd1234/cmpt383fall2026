# Primes_demo.py

#
# Iterators for prime numbers.
#

def is_prime(n):
    """Returns True if n is a prime number, False otherwise."""
    if n < 2:
        return False
    for d in range(2, n):
        if n % d == 0:
            return False
    return True

def next_prime(n):
    """Returns the next prime number after n."""
    while True:
        n += 1
        if is_prime(n):
            return n

# class Primes:
#     def __init__(self):
#         self.value = 1
    
#     def __iter__(self):
#         return self
    
#     def __next__(self):
#         self.value = next_prime(self.value)
#         return self.value

def Primes():
    n = 2
    while True:
        yield n
        n = next_prime(n)

# print the first 5 primes
prime = Primes()
print(next(prime))
print(next(prime))
print(next(prime))

# class Primes_less_than:
#     def __init__(self, max):
#         self.max = max
#         self.primes = Primes()
    
#     def __iter__(self):
#         return self
    
#     def __next__(self):
#         p = next(self.primes)
#         if p < self.max:
#             return p
#         else:
#             raise StopIteration

# for p in Primes_less_than(20):
#     print(p)

# lst = [1 for p in Primes_less_than(1000)]
# print(lst)
# print(sum(1 for p in Primes_less_than(1000)))

