module Value.Value where

import Data.Aeson (FromJSON, Options (sumEncoding), ToJSON, defaultOptions, genericParseJSON, genericToJSON, parseJSON, toJSON)
import Data.Aeson qualified as JSON
import Data.Aeson.Types (Parser, SumEncoding (..))
import Data.Data (Data, Typeable)
import Data.Text (Text)
import Data.UUID (UUID)
import Expression (Expression)
import GHC.Generics (Generic)
import Type (Type)

data Value = Value
    { what :: Type
    , for :: UUID
    , name :: Text
    , expr :: Expression
    }
    deriving (Generic, Data, Typeable, Show, Eq, Ord)

instance FromJSON Value where
    parseJSON :: JSON.Value -> Parser Value
    parseJSON = genericParseJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}

instance ToJSON Value where
    toJSON :: Value -> JSON.Value
    toJSON = genericToJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}
