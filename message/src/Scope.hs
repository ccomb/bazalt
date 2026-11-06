module Scope where

import Data.Aeson (FromJSON (..), ToJSON (..), genericParseJSON, genericToJSON)
import Data.Data (Data)
import Data.UUID (UUID)
import GHC.Generics (Generic)
import Ident.Identification as Identification (Identification)
import Json (taggedOptions)
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
    deriving (Generic, Data, Show, Eq, Ord)

instance FromJSON Scope where
    parseJSON = genericParseJSON taggedOptions

instance ToJSON Scope where
    toJSON = genericToJSON taggedOptions
