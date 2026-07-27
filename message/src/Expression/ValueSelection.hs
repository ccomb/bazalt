module Expression.ValueSelection where

import Data.Aeson as JSON
import Data.Aeson.Types (Parser)
import Data.Data (Data, Typeable)
import Data.Text qualified as T
import Data.UUID (UUID)
import GHC.Generics (Generic)
import Type (Type)

data ValueSelection
    = SelectedValue {what :: Type, for :: UUID, name :: T.Text}
    | UndefinedValue
    deriving (Generic, Data, Typeable, Show, Eq, Ord)

instance FromJSON ValueSelection where
    parseJSON :: JSON.Value -> Parser ValueSelection
    parseJSON = genericParseJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}

instance ToJSON ValueSelection where
    toJSON :: ValueSelection -> JSON.Value
    toJSON = genericToJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}
