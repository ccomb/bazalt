module GroupType.GroupType where

import Data.Aeson as JSON
import Data.Aeson.Types (Parser)
import Data.Data (Data, Typeable)
import Data.UUID (UUID)
import GHC.Generics (Generic)
import Tree qualified
import Type (Type)

data GroupType = GroupType
    { what :: Type
    , uuid :: UUID
    , parent :: Maybe UUID
    , unique :: Bool
    , treeType :: Tree.TreeType
    }
    deriving (Generic, Data, Typeable, Show, Eq, Ord)

instance FromJSON GroupType where
    parseJSON :: JSON.Value -> Parser GroupType
    parseJSON = genericParseJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}

instance ToJSON GroupType where
    toJSON :: GroupType -> JSON.Value
    toJSON = genericToJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}
