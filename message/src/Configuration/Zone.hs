module Configuration.Zone where

import Data.Aeson as JSON
import Data.Aeson.Types (Parser)
import Data.Data (Data)
import GHC.Generics (Generic)

data Zone
    = SmallcardZone
    | MenuZone
    deriving (Generic, Data, Show, Eq, Ord)

instance FromJSON Zone where
    parseJSON :: JSON.Value -> Parser Zone
    parseJSON = genericParseJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}

instance ToJSON Zone where
    toJSON :: Zone -> JSON.Value
    toJSON = genericToJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}
