module Expression.HardLink where

import Data.Aeson as JSON
import Data.Aeson.Types (Parser)
import Data.Data (Data, Typeable)
import GHC.Generics (Generic)

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
    deriving (Generic, Data, Typeable, Show, Eq, Ord)

instance FromJSON HardLink where
    parseJSON :: JSON.Value -> Parser HardLink
    parseJSON = genericParseJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}

instance ToJSON HardLink where
    toJSON :: HardLink -> JSON.Value
    toJSON = genericToJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}

data ResourceLink
    = -- Groups of type Uuid
      ResourceGroup
    | -- ResourceTypes of type Uuid
      ResourceType
    deriving (Generic, Data, Typeable, Show, Eq, Ord)

instance FromJSON ResourceLink where
    parseJSON :: JSON.Value -> Parser ResourceLink
    parseJSON = genericParseJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}

instance ToJSON ResourceLink where
    toJSON :: ResourceLink -> JSON.Value
    toJSON = genericToJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}
data EventLink
    = EventProvider
    | EventReceiver
    | EventInflow
    | EventOutflow
    | EventGroup
    | EventType
    deriving (Generic, Data, Typeable, Show, Eq, Ord)

instance FromJSON EventLink where
    parseJSON :: JSON.Value -> Parser EventLink
    parseJSON = genericParseJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}

instance ToJSON EventLink where
    toJSON :: EventLink -> JSON.Value
    toJSON = genericToJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}

data AgentLink
    = AgentGroup
    | AgentType
    deriving (Generic, Data, Typeable, Show, Eq, Ord)

instance FromJSON AgentLink where
    parseJSON :: JSON.Value -> Parser AgentLink
    parseJSON = genericParseJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}

instance ToJSON AgentLink where
    toJSON :: AgentLink -> JSON.Value
    toJSON = genericToJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}

data CommitmentLink
    = CommitmentProvider
    | CommitmentReceiver
    | CommitmentInflow
    | CommitmentOutflow
    | CommitmentGroup
    | CommitmentType
    deriving (Generic, Data, Typeable, Show, Eq, Ord)

instance FromJSON CommitmentLink where
    parseJSON :: JSON.Value -> Parser CommitmentLink
    parseJSON = genericParseJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}

instance ToJSON CommitmentLink where
    toJSON :: CommitmentLink -> JSON.Value
    toJSON = genericToJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}

data ContractLink
    = ContractGroup
    | ContractType
    deriving (Generic, Data, Typeable, Show, Eq, Ord)

instance FromJSON ContractLink where
    parseJSON :: JSON.Value -> Parser ContractLink
    parseJSON = genericParseJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}

instance ToJSON ContractLink where
    toJSON :: ContractLink -> JSON.Value
    toJSON = genericToJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}

data ProcessLink
    = ProcessGroup
    | ProcessType
    deriving (Generic, Data, Typeable, Show, Eq, Ord)

instance FromJSON ProcessLink where
    parseJSON :: JSON.Value -> Parser ProcessLink
    parseJSON = genericParseJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}

instance ToJSON ProcessLink where
    toJSON :: ProcessLink -> JSON.Value
    toJSON = genericToJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}

data GroupLink
    = GroupGroup
    | GroupType
    | ParentGroup
    deriving (Generic, Data, Typeable, Show, Eq, Ord)

instance FromJSON GroupLink where
    parseJSON :: JSON.Value -> Parser GroupLink
    parseJSON = genericParseJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}

instance ToJSON GroupLink where
    toJSON :: GroupLink -> JSON.Value
    toJSON = genericToJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}

data ResourceTypeLink
    = ResourceTypeGroup
    | ResourceTypeParent
    deriving (Generic, Data, Typeable, Show, Eq, Ord)

instance FromJSON ResourceTypeLink where
    parseJSON :: JSON.Value -> Parser ResourceTypeLink
    parseJSON = genericParseJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}

instance ToJSON ResourceTypeLink where
    toJSON :: ResourceTypeLink -> JSON.Value
    toJSON = genericToJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}

data EventTypeLink
    = EventTypeProvider
    | EventTypeReceiver
    | EventTypeInflow
    | EventTypeOutflow
    | EventTypeGroup
    | EventTypeParent
    deriving (Generic, Data, Typeable, Show, Eq, Ord)

instance FromJSON EventTypeLink where
    parseJSON :: JSON.Value -> Parser EventTypeLink
    parseJSON = genericParseJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}

instance ToJSON EventTypeLink where
    toJSON :: EventTypeLink -> JSON.Value
    toJSON = genericToJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}

data AgentTypeLink
    = AgentTypeGroup
    | AgentTypeParent
    deriving (Generic, Data, Typeable, Show, Eq, Ord)

instance FromJSON AgentTypeLink where
    parseJSON :: JSON.Value -> Parser AgentTypeLink
    parseJSON = genericParseJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}

instance ToJSON AgentTypeLink where
    toJSON :: AgentTypeLink -> JSON.Value
    toJSON = genericToJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}

data CommitmentTypeLink
    = CommitmentTypeProvider
    | CommitmentTypeReceiver
    | CommitmentTypeInflow
    | CommitmentTypeOutflow
    | CommitmentTypeGroup
    | CommitmentTypeParent
    deriving (Generic, Data, Typeable, Show, Eq, Ord)

instance FromJSON CommitmentTypeLink where
    parseJSON :: JSON.Value -> Parser CommitmentTypeLink
    parseJSON = genericParseJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}

instance ToJSON CommitmentTypeLink where
    toJSON :: CommitmentTypeLink -> JSON.Value
    toJSON = genericToJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}

data ContractTypeLink
    = ContractTypeGroup
    | ContractTypeParent
    deriving (Generic, Data, Typeable, Show, Eq, Ord)

instance FromJSON ContractTypeLink where
    parseJSON :: JSON.Value -> Parser ContractTypeLink
    parseJSON = genericParseJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}

instance ToJSON ContractTypeLink where
    toJSON :: ContractTypeLink -> JSON.Value
    toJSON = genericToJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}

data ProcessTypeLink
    = ProcessTypeGroup
    | ProcessTypeParent
    deriving (Generic, Data, Typeable, Show, Eq, Ord)

instance FromJSON ProcessTypeLink where
    parseJSON :: JSON.Value -> Parser ProcessTypeLink
    parseJSON = genericParseJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}

instance ToJSON ProcessTypeLink where
    toJSON :: ProcessTypeLink -> JSON.Value
    toJSON = genericToJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}

data GroupTypeLink
    = GroupTypeGroup
    | GroupTypeParent
    deriving (Generic, Data, Typeable, Show, Eq, Ord)

instance FromJSON GroupTypeLink where
    parseJSON :: JSON.Value -> Parser GroupTypeLink
    parseJSON = genericParseJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}

instance ToJSON GroupTypeLink where
    toJSON :: GroupTypeLink -> JSON.Value
    toJSON = genericToJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}
