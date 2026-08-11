# laundry1.py

# simulates doing laundry
def do_laundry():
    import time
    print("Doing laundry ... ")
    time.sleep(1)
    print("Laundry done")

# Same as do_laundry, but times how long it takes
def do_laundry_timed1():
    import time
    start_time = time.time()
    print("Doing laundry ... ")
    time.sleep(1)
    print("Laundry done")
    end_time = time.time()
    print(f"Time taken: {end_time - start_time} seconds")

# No need to rewrite do_laundry, just call it between the timing code.
def do_laundry_timed2():
    import time
    start_time = time.time()
    do_laundry()
    end_time = time.time()
    print(f"Time taken: {end_time - start_time} seconds")

do_laundry()
print()
do_laundry_timed1()
print()
do_laundry_timed2()
