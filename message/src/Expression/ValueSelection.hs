module Expression.ValueSelection where

import Data.Aeson (FromJSON (..), ToJSON (..), genericParseJSON, genericToJSON)
import Data.Data (Data)
import Data.Text qualified as T
import Data.UUID (UUID)
import GHC.Generics (Generic)
import Json (taggedOptions)
import Type (Type)

data ValueSelection
    = SelectedValue {what :: Type, for :: UUID, name :: T.Text}
    | UndefinedValue
    deriving (Generic, Data, Show, Eq, Ord)

instance FromJSON ValueSelection where
    parseJSON = genericParseJSON taggedOptions

instance ToJSON ValueSelection where
    toJSON = genericToJSON taggedOptions
