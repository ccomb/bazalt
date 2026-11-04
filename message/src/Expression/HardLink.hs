module Expression.HardLink where

import Data.Aeson (FromJSON (..), ToJSON (..), genericParseJSON, genericToJSON)
import Data.Data (Data)
import GHC.Generics (Generic)
import Json (taggedOptions)

data HardLink
    = -- automatically chosen depending on the context ie the selected scope
      ResourceLink ResourceLink
    | EventLink EventLink
    | AgentLink AgentLink
    | CommitmentLink CommitmentLink
    | ContractLink ContractLink
    | ProcessLink ProcessLink
    | GroupLink GroupLink
    | ResourceTypeLink ResourceTypeLink
    | EventTypeLink EventTypeLink
    | AgentTypeLink AgentTypeLink
    | CommitmentTypeLink CommitmentTypeLink
    | ContractTypeLink ContractTypeLink
    | ProcessTypeLink ProcessTypeLink
    | GroupTypeLink GroupTypeLink
    deriving (Generic, Data, Show, Eq, Ord)

data ResourceLink
    = -- Groups of type Uuid
      ResourceGroup
    | -- ResourceTypes of type Uuid
      ResourceType
    deriving (Generic, Data, Show, Eq, Ord)

data EventLink
    = EventProvider
    | EventReceiver
    | EventInflow
    | EventOutflow
    | EventGroup
    | EventType
    deriving (Generic, Data, Show, Eq, Ord)

data AgentLink
    = AgentGroup
    | AgentType
    deriving (Generic, Data, Show, Eq, Ord)

data CommitmentLink
    = CommitmentProvider
    | CommitmentReceiver
    | CommitmentInflow
    | CommitmentOutflow
    | CommitmentGroup
    | CommitmentType
    deriving (Generic, Data, Show, Eq, Ord)

data ContractLink
    = ContractGroup
    | ContractType
    deriving (Generic, Data, Show, Eq, Ord)

data ProcessLink
    = ProcessGroup
    | ProcessType
    deriving (Generic, Data, Show, Eq, Ord)

data GroupLink
    = GroupGroup
    | GroupType
    | ParentGroup
    deriving (Generic, Data, Show, Eq, Ord)

data ResourceTypeLink
    = ResourceTypeGroup
    | ResourceTypeParent
    deriving (Generic, Data, Show, Eq, Ord)

data EventTypeLink
    = EventTypeProvider
    | EventTypeReceiver
    | EventTypeInflow
    | EventTypeOutflow
    | EventTypeGroup
    | EventTypeParent
    deriving (Generic, Data, Show, Eq, Ord)

data AgentTypeLink
    = AgentTypeGroup
    | AgentTypeParent
    deriving (Generic, Data, Show, Eq, Ord)

data CommitmentTypeLink
    = CommitmentTypeProvider
    | CommitmentTypeReceiver
    | CommitmentTypeInflow
    | CommitmentTypeOutflow
    | CommitmentTypeGroup
    | CommitmentTypeParent
    deriving (Generic, Data, Show, Eq, Ord)

data ContractTypeLink
    = ContractTypeGroup
    | ContractTypeParent
    deriving (Generic, Data, Show, Eq, Ord)

data ProcessTypeLink
    = ProcessTypeGroup
    | ProcessTypeParent
    deriving (Generic, Data, Show, Eq, Ord)

data GroupTypeLink
    = GroupTypeGroup
    | GroupTypeParent
    deriving (Generic, Data, Show, Eq, Ord)

instance FromJSON HardLink where
    parseJSON = genericParseJSON taggedOptions

instance ToJSON HardLink where
    toJSON = genericToJSON taggedOptions

instance FromJSON ResourceLink where
    parseJSON = genericParseJSON taggedOptions

instance ToJSON ResourceLink where
    toJSON = genericToJSON taggedOptions

instance FromJSON EventLink where
    parseJSON = genericParseJSON taggedOptions

instance ToJSON EventLink where
    toJSON = genericToJSON taggedOptions

instance FromJSON AgentLink where
    parseJSON = genericParseJSON taggedOptions

instance ToJSON AgentLink where
    toJSON = genericToJSON taggedOptions

instance FromJSON CommitmentLink where
    parseJSON = genericParseJSON taggedOptions

instance ToJSON CommitmentLink where
    toJSON = genericToJSON taggedOptions

instance FromJSON ContractLink where
    parseJSON = genericParseJSON taggedOptions

instance ToJSON ContractLink where
    toJSON = genericToJSON taggedOptions

instance FromJSON ProcessLink where
    parseJSON = genericParseJSON taggedOptions

instance ToJSON ProcessLink where
    toJSON = genericToJSON taggedOptions

instance FromJSON GroupLink where
    parseJSON = genericParseJSON taggedOptions

instance ToJSON GroupLink where
    toJSON = genericToJSON taggedOptions

instance FromJSON ResourceTypeLink where
    parseJSON = genericParseJSON taggedOptions

instance ToJSON ResourceTypeLink where
    toJSON = genericToJSON taggedOptions

instance FromJSON EventTypeLink where
    parseJSON = genericParseJSON taggedOptions

instance ToJSON EventTypeLink where
    toJSON = genericToJSON taggedOptions

instance FromJSON AgentTypeLink where
    parseJSON = genericParseJSON taggedOptions

instance ToJSON AgentTypeLink where
    toJSON = genericToJSON taggedOptions

instance FromJSON CommitmentTypeLink where
    parseJSON = genericParseJSON taggedOptions

instance ToJSON CommitmentTypeLink where
    toJSON = genericToJSON taggedOptions

instance FromJSON ContractTypeLink where
    parseJSON = genericParseJSON taggedOptions

instance ToJSON ContractTypeLink where
    toJSON = genericToJSON taggedOptions

instance FromJSON ProcessTypeLink where
    parseJSON = genericParseJSON taggedOptions

instance ToJSON ProcessTypeLink where
    toJSON = genericToJSON taggedOptions

instance FromJSON GroupTypeLink where
    parseJSON = genericParseJSON taggedOptions

instance ToJSON GroupTypeLink where
    toJSON = genericToJSON taggedOptions
