# counter.py

# class Counter:
#     def __init__(self):
#         self.value = 0
    
#     def next(self):
#         self.value += 1
#         return self.value

def counter_gen():
    value = 1
    while True:
        yield value
        value += 1

gen = counter_gen()
print(next(gen))
print(next(gen))
print(next(gen))
