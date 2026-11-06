{-# LANGUAGE LambdaCase #-}

{- | Checks the output of gen-elm/roundtrip.sh: every message the Haskell
side wrote, once decoded and re-encoded by the Elm side, must decode back
to the same value.
-}
module CrossSpec (spec) where

import Control.Monad (forM_)
import Data.Aeson (eitherDecodeStrict)
import Data.ByteString.Char8 qualified as BS
import Data.Data (dataTypeConstrs, dataTypeOf, showConstr, toConstr)
import Data.List (sort)
import Data.List qualified as List
import Message (Message (..))
import System.Environment (lookupEnv)
import System.FilePath ((</>))
import Test.Hspec (Spec, describe, it, pendingWith, shouldBe)

spec :: Spec
spec = describe "Cross" $ do
    it "every message survives a Haskell to Elm round trip" $ withLines $ \ins outs -> do
        length outs `shouldBe` length ins
        forM_ (zip3 [1 :: Int ..] ins outs) $ \(n, i, o) ->
            (n, decodeShowing o) `shouldBe` (n, decodeShowing i)
    it "the fixtures cover every payload constructor" $ withLines $ \ins _ ->
        case traverse decodeShowing ins of
            Left err -> fail err
            Right [] -> fail "no fixture"
            Right msgs@(m : _) ->
                List.nub (sort (showConstr . toConstr . load <$> msgs))
                    `shouldBe` sort (showConstr <$> dataTypeConstrs (dataTypeOf (load m)))
  where
    withLines check =
        lookupEnv "ROUNDTRIP_DIR" >>= \case
            Nothing -> pendingWith "run gen-elm/roundtrip.sh"
            Just dir -> do
                ins <- BS.lines <$> BS.readFile (dir </> "in.jsonl")
                outs <- BS.lines <$> BS.readFile (dir </> "out.jsonl")
                check ins outs

{- | Decode a line, keeping the line itself in the error: when the Elm side
failed, the line is its own error message.
-}
decodeShowing :: BS.ByteString -> Either String Message
decodeShowing l = either (\e -> Left (e <> ": " <> BS.unpack l)) Right (eitherDecodeStrict l)
