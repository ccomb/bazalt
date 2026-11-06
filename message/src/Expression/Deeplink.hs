module Expression.Deeplink where

import Data.Aeson (FromJSON (..), ToJSON (..), genericParseJSON, genericToJSON)
import Data.Data (Data)
import Data.Text (Text)
import Expression.HardLink as HardLink (HardLink)
import GHC.Generics (Generic)
import Json (taggedOptions)
import Scope (Scope)

data DeepLink
    = Null
    | Link HardLink DeepLink
    | -- the endpoint corresponds to a ValueType
      -- the EndPoint scope is the restriction given by the last hardlink destination
      EndPoint Scope Text
    deriving (Generic, Data, Show, Eq, Ord)

instance FromJSON DeepLink where
    parseJSON = genericParseJSON taggedOptions

instance ToJSON DeepLink where
    toJSON = genericToJSON taggedOptions
