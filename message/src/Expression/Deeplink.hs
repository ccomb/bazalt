module Expression.Deeplink where

import Data.Aeson as JSON
import Data.Aeson.Types (Parser)
import Data.Data (Data, Typeable)
import Expression.HardLink as HardLink (HardLink)
import GHC.Generics (Generic)
import Scope (Scope)

data DeepLink
    = Null
    | Link {hardlink :: HardLink, deeplink :: DeepLink}
    | -- the endpoint corresponds to a ValueType
      -- the EndPoint scope is the restriction given by the last hardlink destination
      EndPoint {scope :: Scope, name :: String}
    deriving (Generic, Data, Typeable, Show, Eq, Ord)

instance FromJSON DeepLink where
    parseJSON :: JSON.Value -> Parser DeepLink
    parseJSON = genericParseJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}

instance ToJSON DeepLink where
    toJSON :: DeepLink -> JSON.Value
    toJSON = genericToJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}
