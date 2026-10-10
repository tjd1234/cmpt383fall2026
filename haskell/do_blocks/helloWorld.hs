import Control.Applicative (Alternative(some))
-- helloWorld.hs

-- In Haskell programs you use a main function to define the entry point of the
-- program. The type of main is important: it's type is IO (), which means that
-- main is a function that does not return a useful value. IO () is a bit like
-- void in C/C++.
--
-- In this example, main prints a string to the console and does not return a
-- value. In other words, main as a side-effect --- printing to the console ---
-- and it is this side-effect that is important to us. It does not return a
-- value of any use.
--
-- The "do" keyword is used to sequence actions. In this example, there is only
-- one action --- printing a string to the console --- but in general you can
-- sequence any number of actions. Sequence actions are performed in the order
-- they are written, just like statements in a C/C++ program.
--
-- The putStrLn function prints a string (plus a newline) to the console. It's
-- type is:
--
--    putStrLn :: String -> IO ()
--
-- In other words, putStrLn takes a String and as input and returns an IO (),
-- i.e. it does not return a useful value.
--

main :: IO ()
main = do
    putStrLn "Hello, world!"
