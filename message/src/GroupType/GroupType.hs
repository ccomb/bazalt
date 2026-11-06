module GroupType.GroupType where

import Data.Aeson (FromJSON (..), ToJSON (..), genericParseJSON, genericToJSON)
import Data.Data (Data)
import Data.UUID (UUID)
import GHC.Generics (Generic)
import Json (taggedOptions)
import Tree qualified
import Type (Type)

data GroupType = GroupType
    { what :: Type
    , uuid :: UUID
    , parent :: Maybe UUID
    , unique :: Bool
    , treeType :: Tree.TreeType
    }
    deriving (Generic, Data, Show, Eq, Ord)

instance FromJSON GroupType where
    parseJSON = genericParseJSON taggedOptions

instance ToJSON GroupType where
    toJSON = genericToJSON taggedOptions
