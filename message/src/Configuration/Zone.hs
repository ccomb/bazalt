module Configuration.Zone where

import Data.Aeson (FromJSON (..), ToJSON (..), genericParseJSON, genericToJSON)
import Data.Data (Data)
import GHC.Generics (Generic)
import Json (taggedOptions)

data Zone
    = SmallcardZone
    | MenuZone
    deriving (Generic, Data, Show, Eq, Ord)

instance FromJSON Zone where
    parseJSON = genericParseJSON taggedOptions

instance ToJSON Zone where
    toJSON = genericToJSON taggedOptions
