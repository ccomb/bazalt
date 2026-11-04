module EventType.EventType where

import Data.Aeson (FromJSON (..), ToJSON (..), genericParseJSON, genericToJSON)
import Data.Data (Data)
import Data.UUID (UUID)
import Expression (Expression)
import GHC.Generics (Generic)
import Json (taggedOptions)
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
    deriving (Generic, Data, Show, Eq, Ord)

instance FromJSON EventType where
    parseJSON = genericParseJSON taggedOptions

instance ToJSON EventType where
    toJSON = genericToJSON taggedOptions
