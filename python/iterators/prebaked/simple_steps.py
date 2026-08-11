# simple_steps.py

def simple_steps():
    yield "Step A"
    yield "Step B"
    yield "Step C"

for step in simple_steps():
    print(step)
