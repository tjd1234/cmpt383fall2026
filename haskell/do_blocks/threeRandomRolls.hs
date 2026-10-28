-- threeRandomRolls.hs

-- oneRandomRoll.hs
import System.Random
-- may need to install, e.g.: cabal install --lib random 

main :: IO ()
main = do
    putStrLn "Rolling three 6-sided dice ..."
    roll1 <- randomRIO (1, 6 :: Int)
    roll2 <- randomRIO (1, 6 :: Int)
    roll3 <- randomRIO (1, 6 :: Int)
    putStrLn ("  You rolled: " ++ show roll1 ++ ", " ++ show roll2 ++ ", " ++ show roll3)
    putStrLn ("The total is: " ++ show (roll1 + roll2 + roll3))
