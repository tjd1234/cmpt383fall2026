# laundry3.py

# Assuming the function f takes no parameters, this function returns a new
# function that times f.
def make_timed_function(f):
    def timed_function():
        import time
        start_time = time.time()
        result = f()
        end_time = time.time()
        print(f"Time taken: {end_time - start_time} seconds")
        return result
    return timed_function

# simulates doing laundry
@make_timed_function
def do_laundry():
    import time
    print("Doing laundry ... ")
    time.sleep(1)
    print("Laundry done")

do_laundry()
