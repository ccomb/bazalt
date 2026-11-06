module Value.Value where

import Data.Aeson (FromJSON (..), ToJSON (..), genericParseJSON, genericToJSON)
import Data.Data (Data)
import Data.Text (Text)
import Data.UUID (UUID)
import Expression (Expression)
import GHC.Generics (Generic)
import Json (taggedOptions)
import Type (Type)

data Value = Value
    { what :: Type
    , for :: UUID
    , name :: Text
    , expr :: Expression
    }
    deriving (Generic, Data, Show, Eq, Ord)

instance FromJSON Value where
    parseJSON = genericParseJSON taggedOptions

instance ToJSON Value where
    toJSON = genericToJSON taggedOptions
