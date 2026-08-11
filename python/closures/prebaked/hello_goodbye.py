# hello_goodbye.py

# This function takes a function f and returns a new function that prints "f
# called ..." before calling f and prints "... f done" after calling f.
def make_hello_goodbye(f):
    def hello_goodbye(*args, **kwargs):
        print(f"{f.__name__} called ...")
        result = f(*args, **kwargs)
        print(f"... {f.__name__} done")
        return result
    return hello_goodbye

def make_timed_function(f):
    def timed_function(*args, **kwargs):
        import time
        start_time = time.time()
        result = f(*args, **kwargs)
        end_time = time.time()
        print(f"Time taken: {end_time - start_time} seconds")
        return result
    return timed_function

@make_hello_goodbye
# @make_timed_function
def do_laundry():
    import time
    print("Doing laundry ... ")
    time.sleep(1)
    print("Laundry done")

do_laundry()
