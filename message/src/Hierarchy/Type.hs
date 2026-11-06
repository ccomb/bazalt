module Hierarchy.Type (Type (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericParseJSON, genericToJSON)
import Data.Data (Data)
import GHC.Generics (Generic)
import Json (taggedOptions)

-- | The kind of a type, which describes entities and forms a hierarchy.
data Type
    = ResourceType
    | EventType
    | AgentType
    | CommitmentType
    | ContractType
    | ProcessType
    | GroupType
    deriving (Generic, Data, Show, Eq, Ord, Enum, Bounded)

instance FromJSON Type where
    parseJSON = genericParseJSON taggedOptions

instance ToJSON Type where
    toJSON = genericToJSON taggedOptions
