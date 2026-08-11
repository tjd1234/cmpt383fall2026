-- repeatName.hs

-- This program reads a name and a number and prints the name that number of
-- times. After the number is read from the user into numStr, we convert it to
-- an Int using the read function:
--
--    let n = (read numStr) :: Int
--
-- The :: Int is a type annotation, which tells the compiler that the result of
-- the read function is an Int.
--
-- Why do use let here, instead of, say, n <- (read numStr) :: Int? The reason
-- is that <- only works with functions that return IO values, and read returns
-- an Int in this case and so cannot work with <-.
--
-- Once we have n, we pass it to the printName function that prints the name n
-- times. Note that type of printName:
--
--   printName :: String -> Int -> IO ()
--
-- It takes a String and an Int and returns an IO (), i.e. it does not return a
-- useful value because it is a kind of print function that we are calling only
-- for its side-effect of printing the name n times.
--
-- Notice the "then" statement returns the value "return ()", which is an IO ()
-- value that means "do nothing".
--

main :: IO ()
main = do
    putStr "What is your name? "
    name <- getLine
    putStr "How many times should I print it? "
    numStr <- getLine
    let n = (read numStr) :: Int
    printName name n

printName :: String -> Int -> IO ()
printName name n =
    if n <= 0
    then return ()
    else do
           putStrLn name
           printName name (n - 1)
