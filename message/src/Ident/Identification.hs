module Ident.Identification where

import Data.Aeson (FromJSON, Options (sumEncoding), ToJSON, defaultOptions, genericParseJSON, genericToJSON, parseJSON, toJSON)
import Data.Aeson qualified as JSON
import Data.Aeson.Types (Parser, SumEncoding (..))
import Data.Data (Data, Typeable)
import GHC.Generics (Generic)

data Identification
    = StartsWith String
    | EndsWith String
    | Contains String
    deriving (Generic, Data, Typeable, Show, Eq, Ord)

instance FromJSON Identification where
    parseJSON :: JSON.Value -> Parser Identification
    parseJSON = genericParseJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}

instance ToJSON Identification where
    toJSON :: Identification -> JSON.Value
    toJSON = genericToJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}
