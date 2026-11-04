{-# LANGUAGE OverloadedStrings #-}

{- | Writes messages to stdout, one JSON line each, for the Haskell to Elm
round trip: random ones from fixed seeds, then the edge cases the random
ones are unlikely to hit.
-}
module Main (main) where

import Arbitrary ()
import Data.Aeson (encode)
import Data.ByteString.Lazy.Char8 qualified as BL
import Expression (Expression (..))
import Expression.Observable (Observable (Constant))
import Expression.Unary qualified as Unary
import Group.Group qualified as Group
import Message (Message (..))
import MessageFlow (MessageFlow (Error))
import Metadata (Metadata)
import Metadata qualified
import Payload (Payload (..))
import Scope (Scope (..))
import Test.QuickCheck (Arbitrary (arbitrary))
import Test.QuickCheck.Gen (Gen, unGen)
import Test.QuickCheck.Random (mkQCGen)
import Value.Value qualified as Value

main :: IO ()
main = mapM_ (BL.putStrLn . encode) (randoms <> edgeCases)

-- | Enough random messages to meet every payload constructor.
randoms :: [Message]
randoms = [sample arbitrary seed (seed `mod` 30) | seed <- [1 .. 2000]]

edgeCases :: [Message]
edgeCases =
    [ withLoad (DefinedGroup (sample arbitrary 1 5){Group.scope = nest 50 (`And` Empty) Anything})
    , withLoad (AddedValue (sample arbitrary 2 5){Value.expr = nest 50 (Unary Unary.Neg) (Leaf (Constant 1))})
    , withMeta (\m -> m{Metadata.when = 1695927356.951})
    , withMeta (\m -> m{Metadata.flow = Error "raison"})
    ]
  where
    base = sample arbitrary 3 5 :: Message
    withLoad p = base{load = p}
    withMeta :: (Metadata -> Metadata) -> Message
    withMeta f = base{meta = f (meta base)}

sample :: Gen a -> Int -> Int -> a
sample g seed = unGen g (mkQCGen seed)

nest :: Int -> (a -> a) -> a -> a
nest n f x = foldr (const f) x [1 .. n]
