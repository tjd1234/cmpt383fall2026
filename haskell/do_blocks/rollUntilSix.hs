-- rollUntilSix.hs
import System.Random

main :: IO ()
main = do
    putStrLn "Rolling until we get a 6 ..."
    rollUntilSix 1

rollUntilSix :: Int -> IO ()
rollUntilSix n = do
    roll <- randomRIO (1, 6 :: Int)
    putStrLn ("You rolled a " ++ show roll)
    if roll == 6
    then putStrLn ("Got a 6 after " ++ show n ++ " rolls.")
    else rollUntilSix (n + 1)
