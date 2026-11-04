module Expression.Binary where

import Data.Aeson (FromJSON (..), ToJSON (..), genericParseJSON, genericToJSON)
import Data.Data (Data)
import Data.Text as T
import GHC.Generics (Generic)
import Json (taggedOptions)

data Operator
    = Add
    | Multiply
    | Or {name :: T.Text, desc :: T.Text, choice :: Maybe Bool}
    | Otherwise
    deriving (Generic, Data, Show, Eq, Ord)

instance FromJSON Operator where
    parseJSON = genericParseJSON taggedOptions

instance ToJSON Operator where
    toJSON = genericToJSON taggedOptions
