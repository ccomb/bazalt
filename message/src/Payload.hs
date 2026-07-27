module Payload where

import Agent.Agent (Agent)
import AgentType.AgentType (AgentType)
import Commitment.Commitment (Commitment)
import CommitmentType.CommitmentType (CommitmentType)
import Configuration (Configuration)
import Connection
import Contract.Contract (Contract)
import ContractType.ContractType (ContractType)
import Data.Aeson (FromJSON, Options (sumEncoding), ToJSON, defaultOptions, genericParseJSON, genericToJSON, parseJSON, toJSON)
import Data.Aeson qualified as JSON
import Data.Aeson.Types (Parser, SumEncoding (..))
import Data.Data (Data, Typeable)
import Data.UUID (UUID)
import Event.Event (Event)
import EventType.EventType (EventType)
import GHC.Generics (Generic)
import Group.Group (Group)
import Group.Link as GroupLink (Link)
import GroupType.GroupType (GroupType)
import Ident.Identifier (Identifier)
import Ident.IdentifierType (IdentifierType)
import Process.Process (Process)
import Process.Reconcile (Reconciliation)
import ProcessType.ProcessType (ProcessType)
import Resource.Resource (Resource)
import ResourceType.ResourceType (ResourceType)
import Value.Value (Value)
import Value.ValueType (ValueType)

data Payload
    = InitiatedConnection Connection
    | AddedResourceType ResourceType
    | RemovedResourceType UUID
    | AddedEventType EventType
    | RemovedEventType UUID
    | AddedAgentType AgentType
    | RemovedAgentType UUID
    | AddedCommitmentType CommitmentType
    | RemovedCommitmentType UUID
    | AddedContractType ContractType
    | RemovedContractType UUID
    | AddedProcessType ProcessType
    | RemovedProcessType UUID
    | AddedResource Resource
    | RemovedResource UUID
    | AddedEvent Event
    | RemovedEvent UUID
    | AddedAgent Agent
    | RemovedAgent UUID
    | AddedCommitment Commitment
    | RemovedCommitment UUID
    | AddedContract Contract
    | RemovedContract UUID
    | AddedProcess Process
    | RemovedProcess UUID
    | AddedIdentifierType IdentifierType
    | ChangedIdentifierType {old :: IdentifierType, new :: IdentifierType}
    | RemovedIdentifierType IdentifierType
    | AddedIdentifier Identifier
    | AddedValueType ValueType
    | ChangedValueType ValueType ValueType
    | RemovedValueType ValueType
    | AddedValue Value
    | Configured Configuration
    | Unconfigured Configuration
    | AddedGroupType GroupType
    | RemovedGroupType UUID
    | DefinedGroup Group
    | RemovedGroup UUID
    | Grouped GroupLink.Link
    | Ungrouped GroupLink.Link
    | Reconciled Reconciliation
    | Unreconciled Reconciliation
    deriving (Generic, Data, Typeable, Show, Eq, Ord)

instance FromJSON Payload where
    parseJSON :: JSON.Value -> Parser Payload
    parseJSON = genericParseJSON $ defaultOptions{sumEncoding = TaggedObject{tagFieldName = "what", contentsFieldName = "load"}}

instance ToJSON Payload where
    toJSON :: Payload -> JSON.Value
    toJSON = genericToJSON $ defaultOptions{sumEncoding = TaggedObject{tagFieldName = "what", contentsFieldName = "load"}}
