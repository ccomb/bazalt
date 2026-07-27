{-# LANGUAGE OverloadedStrings #-}

module Scope where

import Data.Aeson (FromJSON, ToJSON, parseJSON, toJSON, withObject, (.:), (.=))
import Data.Aeson qualified as JSON
import Data.Aeson.Types (Parser)
import Data.Data (Data, Typeable, toConstr)
import Data.Text (Text)
import Data.UUID (UUID)
import GHC.Generics (Generic)
import Ident.Identification as Identification (Identification)
import Type (Type)

data Scope
    = -- a scope is the definition of a set of items:
      -- Either an empty set:
      Empty
    | -- or the set of all sets
      Anything
    | -- A set with a single item of type Type:
      IsItem Type UUID
    | -- the set of items of type Type whose what or parent is child of a precise user type
      HasUserType Type UUID
    | -- The set of items with a specific concrete type:
      HasType Type
    | -- The union of two sets
      And Scope Scope -- entities of both groups
      -- An alternative between two sets.
    | Or Scope Scope -- entities of either group
    -- Everything but the set
    | Not Scope -- entities not in the group
    -- the set of items with a specific identification
    | Identified Identification -- entities identified somehow
    deriving (Generic, Data, Typeable, Show, Eq, Ord)

instance FromJSON Scope where
    parseJSON :: JSON.Value -> Parser Scope
    parseJSON =
        withObject
            "Scope"
            ( \o -> do
                s <- o .: "type" :: Parser Text
                case s of
                    "Empty" -> return Empty
                    "Anything" -> return Anything
                    "IsItem" -> IsItem <$> o .: "what" <*> o .: "uuid"
                    "HasUserType" -> HasUserType <$> o .: "what" <*> o .: "uuid"
                    "HasType" -> do
                        t <- o .: "what"
                        HasType <$> parseJSON t
                    "And" -> And <$> o .: "scope1" <*> o .: "scope2"
                    "Or" -> Or <$> o .: "scope1" <*> o .: "scope2"
                    "Not" -> Not <$> o .: "scope"
                    "Identified" -> do
                        v <- o .: "value"
                        Identified <$> v .: "value"
                    _ -> fail "Invalid Scope"
            )

instance ToJSON Scope where
    toJSON :: Scope -> JSON.Value
    toJSON scope =
        let constr = show $ toConstr scope
         in case scope of
                Empty -> JSON.object ["type" .= constr]
                Anything -> JSON.object ["type" .= constr]
                IsItem what uuid -> JSON.object ["type" .= constr, "what" .= what, "uuid" .= uuid]
                HasUserType what uuid -> JSON.object ["type" .= constr, "what" .= what, "uuid" .= uuid]
                HasType what -> JSON.object ["type" .= constr, "what" .= what]
                And scope1 scope2 -> JSON.object ["type" .= constr, "scope1" .= toJSON scope1, "scpe1" .= toJSON scope2]
                Or scope1 scope2 -> JSON.object ["type" .= constr, "scope1" .= toJSON scope1, "scpe1" .= toJSON scope2]
                Not s -> JSON.object ["type" .= constr, "scope" .= toJSON s]
                Identified ident -> JSON.object ["type" .= constr, "value" .= toJSON ident]
