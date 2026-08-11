# laundry2.py

# simulates doing laundry
def do_laundry():
    import time
    print("Doing laundry ... ")
    time.sleep(1)
    print("Laundry done")

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

timed_do_laundry = make_timed_function(do_laundry)
timed_do_laundry()
