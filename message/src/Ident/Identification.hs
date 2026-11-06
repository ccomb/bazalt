module Ident.Identification where

import Data.Aeson (FromJSON (..), ToJSON (..), genericParseJSON, genericToJSON)
import Data.Data (Data)
import Data.Text (Text)
import GHC.Generics (Generic)
import Json (taggedOptions)

data Identification
    = StartsWith Text
    | EndsWith Text
    | Contains Text
    deriving (Generic, Data, Show, Eq, Ord)

instance FromJSON Identification where
    parseJSON = genericParseJSON taggedOptions

instance ToJSON Identification where
    toJSON = genericToJSON taggedOptions
