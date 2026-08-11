# enumerator_demo.py

pets = ['cat', 'dog', 'bird']
print(f'pets: {pets}\n')

print('enumerated:')
for i, pet in enumerate(pets):
    print(i, pet)

print('\nreversed:')
for pet in reversed(pets):
    print(pet)

for i in reversed(range(5)):
    print(i)
