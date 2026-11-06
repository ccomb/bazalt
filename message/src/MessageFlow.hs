module MessageFlow where

import Data.Aeson (FromJSON (..), ToJSON (..), genericParseJSON, genericToJSON)
import Data.Data (Data)
import Data.Text (Text)
import GHC.Generics (Generic)
import Json (taggedOptions)

data MessageFlow
    = Requested
    | Processed
    | Error Text
    deriving (Eq, Generic, Data, Ord, Show)

instance FromJSON MessageFlow where
    parseJSON = genericParseJSON taggedOptions

instance ToJSON MessageFlow where
    toJSON = genericToJSON taggedOptions
