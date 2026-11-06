module Type where

import Data.Aeson (FromJSON (..), ToJSON (..), genericParseJSON, genericToJSON)
import Data.Data (Data)
import GHC.Generics
import Json (taggedOptions)

data Type
    = ResourceType
    | EventType
    | AgentType
    | CommitmentType
    | ContractType
    | ProcessType
    | GroupType
    | Resource
    | Event
    | Agent
    | Commitment
    | Contract
    | Process
    | Group
    deriving (Generic, Data, Show, Ord, Eq)

instance FromJSON Type where
    parseJSON = genericParseJSON taggedOptions

instance ToJSON Type where
    toJSON = genericToJSON taggedOptions
