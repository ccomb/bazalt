{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE OverloadedStrings #-}

module Type where

import Data.Aeson
import Data.Data (Data, Typeable)
import GHC.Generics

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
    deriving (Generic, Data, Typeable, Show, Ord, Eq)

instance FromJSON Type where
    parseJSON = \case
        "ResourceType" -> return ResourceType
        "EventType" -> return EventType
        "AgentType" -> return AgentType
        "CommitmentType" -> return CommitmentType
        "ContractType" -> return ContractType
        "ProcessType" -> return ProcessType
        "GroupType" -> return GroupType
        "Resource" -> return Resource
        "Event" -> return Event
        "Agent" -> return Agent
        "Commitment" -> return Commitment
        "Contract" -> return Contract
        "Process" -> return Process
        "Group" -> return Group
        _ -> fail "Invalid REA Type"

instance ToJSON Type where
    toJSON = genericToJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}
