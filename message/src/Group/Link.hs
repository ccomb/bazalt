module Group.Link where

import Data.Aeson as JSON
import Data.Aeson.Types (Parser)
import Data.Data (Data, Typeable)
import Data.UUID (UUID)
import GHC.Generics (Generic)
import Type (Type)

data Link = Link
    -- the groupable is in the group
    { what :: Type
    , groupable :: UUID
    , group :: UUID
    }
    deriving (Generic, Data, Typeable, Show, Eq, Ord)

instance FromJSON Link where
    parseJSON :: JSON.Value -> Parser Link
    parseJSON = genericParseJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}

instance ToJSON Link where
    toJSON :: Link -> JSON.Value
    toJSON = genericToJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}
