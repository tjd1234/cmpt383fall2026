-- oneRandomRoll.hs
import System.Random
-- may need to install, e.g.: cabal install --lib random 

main :: IO ()
main = do
    putStrLn "Rolling a 6-sided die ..."
    roll <- randomRIO (1, 6 :: Int)
    putStrLn ("You rolled: " ++ show roll)
