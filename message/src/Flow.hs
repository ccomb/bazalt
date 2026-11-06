module Flow where

import Data.Aeson (FromJSON (..), ToJSON (..), genericParseJSON, genericToJSON)
import Data.Data (Data)
import GHC.Generics (Generic)
import Json (taggedOptions)
import Resource.Resource (Resource)
import ResourceType.ResourceType (ResourceType)

data Flow
    = ResourceFlow Resource
    | ResourceTypeFlow ResourceType
    deriving (Generic, Data, Show, Eq, Ord)

instance FromJSON Flow where
    parseJSON = genericParseJSON taggedOptions

instance ToJSON Flow where
    toJSON = genericToJSON taggedOptions
