# enumerator_demo.py

pets = ['cat', 'dog', 'bird', 'slug']
print(f'pets: {pets}\n')

for i, p in enumerate(reversed(pets)):
    print(i, p)
