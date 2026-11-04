module AgentType.AgentType where

import Data.Aeson (FromJSON (..), ToJSON (..), genericParseJSON, genericToJSON)
import Data.Data (Data)
import Data.UUID (UUID)
import GHC.Generics (Generic)
import Json (taggedOptions)
import Type (Type)

data AgentType = AgentType
    { what :: Type
    , uuid :: UUID
    , parent :: Maybe UUID
    }
    deriving (Generic, Data, Show, Eq, Ord)

instance FromJSON AgentType where
    parseJSON = genericParseJSON taggedOptions

instance ToJSON AgentType where
    toJSON = genericToJSON taggedOptions
