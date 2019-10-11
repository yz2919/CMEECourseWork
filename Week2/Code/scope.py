_a_global = 10 #a global variable

if _a_global >= 5:
    _b_global = _a_global + 5 #a global variable

def a_function():
    _a_global = 5 #local

    if _a_global >= 5:
        _b_global = _a_global + 5 #local
    
    _a_local = 4
    print("Inside the function, the value of _a_global is ", _a_global)
    print("Inside the function, the value of _b_global is ", _b_global)
    print("Inside the function, the value of _a_local is ", _a_local)
    
    return None

a_function()

print("Outside the function, the value of _a_global is ", _a_global)
print("Outside the function, the value of _b_global is ", _b_global)