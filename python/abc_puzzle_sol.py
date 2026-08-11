# abc_puzzle_sol.py

#
# Find all 3-digit numbers ABC such that 
# - A, B, and C are all different 
# - ABC + CBA is a number whose digits are all the same
# - A and B are not 0 (to avoid leading zeros)
# - ABC < CBA
#

def demo1():
    num_tests = 0
    num_solutions = 0
    for a in range(1, 10):
        for b in range(10):
            if a == b: continue
            for c in range(1, 10):
                if c == a or c == b: continue
                abc = 100 * a + 10 * b + c
                cba = 100 * c + 10 * b + a
                if not (abc < cba): continue
                num_tests += 1
                n = abc + cba
                s = str(n)
                if len(s) == 3 and len(set(s)) == 1:
                    print(f"{abc} + {cba} = {n}")
                    num_solutions += 1

    print(f"    Number of tests: {num_tests}")
    print(f"Number of solutions: {num_solutions}")


def demo2():
    solutions = [(a, b, c) for a in range(1, 10) 
                           for b in range(10)
                           if a != b
                           for c in range(1, 10) 
                           if a != b and b != c and a != c
                           if 100*a + 10*b + c < 100*c + 10*b + a
                           if len(set(str(100*a + 10*b + c + 100*c + 10*b + a))) == 1
                           if len(str(100*a + 10*b + c + 100*c + 10*b + a)) == 3
                           ]
    print(solutions)
    print(f"Number of solutions: {len(solutions)}")

# Uses the walrus operator to define the variables abc and cba, making the code
# more concise and (hopefully) more efficient.
def demo3():
    solutions = [(a, b, c) for a in range(1, 10) 
                           for b in range(10)
                           if a != b
                           for c in range(1, 10) 
                           if a != b and b != c and a != c
                           if (abc:=100*a + 10*b + c) < (cba:=100*c + 10*b + a)
                           if len(set(str(abc + cba))) == 1
                           if len(str(abc + cba)) == 3
                           ]
    print(solutions)
    print(f"Number of solutions: {len(solutions)}")

demo1()
demo2()
demo3()
