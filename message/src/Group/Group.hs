module Group.Group where

import Data.Aeson (FromJSON (..), ToJSON (..), genericParseJSON, genericToJSON)
import Data.Data (Data)
import Data.UUID (UUID)
import GHC.Generics (Generic)
import Json (taggedOptions)
import Scope (Scope)
import Type (Type)

data Group = Group
    { what :: Type
    , uuid :: UUID
    , type_ :: UUID
    , parent :: Maybe UUID
    , -- The scope defines what a group can contain
      scope :: Scope
    }
    deriving (Generic, Data, Show, Eq, Ord)

instance FromJSON Group where
    parseJSON = genericParseJSON taggedOptions

instance ToJSON Group where
    toJSON = genericToJSON taggedOptions
