# Primes_gen_demo.py

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

def primes_gen():
    """Yields all the prime numbers."""
    n = 2
    while True:
        yield n
        n = next_prime(n)
