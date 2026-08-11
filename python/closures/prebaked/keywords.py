# keywords.py

def create_profile(username, age, account_type):
    print(f"User: {username}, Age: {age}, Type: {account_type}")

# Calling the function using keyword arguments. The order is rearranged, but the
# code still works correctly.
create_profile(account_type="Premium", username="Alice", age=28)
