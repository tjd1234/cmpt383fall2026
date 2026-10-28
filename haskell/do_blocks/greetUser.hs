-- greetUser.hs

--
-- This programs asks the user for their name, and then greets them.
--
-- As before, it's in a main function with the type IO (), i.e. main does not
-- return a useful value.
--
-- The putSter and putStrLn functions both have the type String -> IO (), i.e.
-- they take a String as input and return an IO ().
--
-- The line "name <- getLine" is a binding statement. It binds the result of the
-- getLine function to the variable name. <- can only be used in do blocks.
-- getLine has thet type IO String, i.e. it takes no input and returns an IO
-- String, i.e. it returns a String typed in to the console by the user.
--

main :: IO ()
main = do
    putStr "What is your name? "
    name <- getLine
    putStrLn ("Hello, " ++ name ++ "!")