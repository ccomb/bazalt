module Resource.Resource where

import Data.Aeson as JSON
import Data.Aeson.Types (Parser)
import Data.Data (Data, Typeable)
import Data.UUID (UUID)
import GHC.Generics (Generic)
import Type (Type)

data Resource = Resource
    { what :: Type
    , uuid :: UUID
    , type_ :: UUID
    , qty :: Rational
    }
    deriving (Generic, Data, Typeable, Show, Eq, Ord)

instance FromJSON Resource where
    parseJSON :: JSON.Value -> Parser Resource
    parseJSON = genericParseJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}

instance ToJSON Resource where
    toJSON :: Resource -> JSON.Value
    toJSON = genericToJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}
