module Process.Process where

import Data.Aeson as JSON
import Data.Aeson.Types (Parser)
import Data.Data (Data, Typeable)
import Data.UUID (UUID)
import GHC.Generics (Generic)
import Type (Type)

data Process = Process
    { what :: Type
    , uuid :: UUID
    , type_ :: UUID
    }
    deriving (Generic, Data, Typeable, Show, Eq, Ord)

instance FromJSON Process where
    parseJSON :: JSON.Value -> Parser Process
    parseJSON = genericParseJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}

instance ToJSON Process where
    toJSON :: Process -> JSON.Value
    toJSON = genericToJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}
