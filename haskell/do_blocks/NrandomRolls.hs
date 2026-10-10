-- NrandomRolls.hs
import System.Random

main :: IO ()
main = do
    putStr "How many dice would you like to roll? "
    numStr <- getLine
    let n = read numStr :: Int
    rollDice n

rollDice :: Int -> IO ()
rollDice n =
    if n <= 0
        then return ()
        else do
            roll <- randomRIO (1, 6 :: Int)
            putStrLn ("You rolled a " ++ show roll)
            rollDice (n - 1)