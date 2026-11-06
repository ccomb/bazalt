module Group.Link where

import Data.Aeson (FromJSON (..), ToJSON (..), genericParseJSON, genericToJSON)
import Data.Data (Data)
import Data.UUID (UUID)
import GHC.Generics (Generic)
import Json (taggedOptions)
import Type (Type)

data Link = Link
    -- the groupable is in the group
    { what :: Type
    , groupable :: UUID
    , group :: UUID
    }
    deriving (Generic, Data, Show, Eq, Ord)

instance FromJSON Link where
    parseJSON = genericParseJSON taggedOptions

instance ToJSON Link where
    toJSON = genericToJSON taggedOptions
