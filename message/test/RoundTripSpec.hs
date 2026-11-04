{-# LANGUAGE OverloadedStrings #-}

module RoundTripSpec (spec) where

import Arbitrary ()
import Data.Aeson (decode, encode)
import Message (Message)
import MessageFlow (MessageFlow (..))
import Payload (Payload)
import Expression (Expression)
import Scope (Scope (..))
import Test.Hspec (Spec, describe, it, shouldBe)
import Test.Hspec.QuickCheck (prop)
import Test.QuickCheck ((===))

spec :: Spec
spec = describe "JSON round trip" $ do
    it "Scope And keeps its second operand" $
        decode (encode (And Anything Empty)) `shouldBe` Just (And Anything Empty)
    it "an Error whose reason is a flow name stays an Error" $
        decode (encode (Error "Processed")) `shouldBe` Just (Error "Processed")
    prop "Scope" $ \(s :: Scope) -> decode (encode s) === Just s
    prop "Expression" $ \(e :: Expression) -> decode (encode e) === Just e
    prop "Payload" $ \(p :: Payload) -> decode (encode p) === Just p
    prop "Message" $ \(m :: Message) -> decode (encode m) === Just m
