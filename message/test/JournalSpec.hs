{-# LANGUAGE LambdaCase #-}

module JournalSpec (spec) where

import Data.Aeson (encode)
import Data.ByteString.Lazy.Char8 qualified as BL
import Data.UUID (nil)
import Message (JournalError (..), Message (..), readMessages)
import MessageFlow (MessageFlow (Requested))
import Metadata (Metadata (..))
import Payload (Payload (RemovedAgent))
import System.FilePath ((</>))
import System.IO.Temp (withSystemTempDirectory)
import Test.Hspec (Spec, describe, it, shouldBe, shouldSatisfy)

spec :: Spec
spec = describe "Journal" $ do
    it "stops on the first undecodable line, naming it" $
        withSystemTempDirectory "journal" $ \dir -> do
            let path = dir </> "messagestore.txt"
                valid = Message (Metadata nil 0 [] Requested) (RemovedAgent nil)
            BL.writeFile path $ BL.unlines [encode valid, BL.pack "{not json}"]
            r <- readMessages path
            r `shouldSatisfy` \case
                Left (BadLine _ 2 _) -> True
                _ -> False
    it "reads a missing journal as an empty one" $
        withSystemTempDirectory "journal" $ \dir -> do
            r <- readMessages (dir </> "absent.txt")
            r `shouldBe` Right []
