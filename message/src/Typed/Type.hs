module Typed.Type (Type (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericParseJSON, genericToJSON)
import Data.Data (Data)
import GHC.Generics (Generic)
import Json (taggedOptions)

-- | The kind of an entity of the operational level.
data Type
    = Resource
    | Event
    | Agent
    | Commitment
    | Contract
    | Process
    | Group
    deriving (Generic, Data, Show, Eq, Ord, Enum, Bounded)

instance FromJSON Type where
    parseJSON = genericParseJSON taggedOptions

instance ToJSON Type where
    toJSON = genericToJSON taggedOptions
