# timed_fn.py

# This function takes a function f and returns a new function that times f. f
# can have any number of parameters.
def make_timed_function(f):
    def timed_function(*args, **kwargs):
        import time
        start_time = time.time()
        result = f(*args, **kwargs)
        end_time = time.time()
        print(f"Time taken: {end_time - start_time} seconds")
        return result
    return timed_function

@make_timed_function
def do_laundry(who, duration=1):
    import time
    print(f"{who} is doing laundry ... ")
    time.sleep(duration)
    print(f"{who}'s laundry is done")

do_laundry("Elon", 1.2)

# @make_timed_function
# def factorial(n):
#     result = 1
#     for i in range(1, n + 1):
#         result *= i
#     return result

# print(factorial(40))

