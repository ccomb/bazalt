module EventType.EventType where

import Data.Aeson as JSON
import Data.Aeson.Types (Parser)
import Data.Data (Data, Typeable)
import Data.UUID (UUID)
import Expression (Expression)
import GHC.Generics (Generic)
import Scope (Scope)
import Type (Type)

data EventType = EventType
    { what :: Type
    , uuid :: UUID
    , parent :: Maybe UUID
    , providers :: Scope
    , receivers :: Scope
    , resources :: Scope
    , createResource :: Bool
    , qty :: Expression
    }
    deriving (Generic, Data, Typeable, Show, Eq, Ord)

instance FromJSON EventType where
    parseJSON :: JSON.Value -> Parser EventType
    parseJSON = genericParseJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}

instance ToJSON EventType where
    toJSON :: EventType -> JSON.Value
    toJSON = genericToJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}
