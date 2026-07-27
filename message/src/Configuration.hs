module Configuration where

import Configuration.Zone (Zone)

import Configuration.Zone.Fragment (Fragment)
import Data.Aeson as JSON
import Data.Aeson.Types (Parser)
import Data.Data (Data, Typeable)
import Data.UUID (UUID)
import GHC.Generics (Generic)
import Scope (Scope)
import Type (Type)

data Configuration
    = -- the list of identifier types to display on each zone
      ZoneDisplay {zone :: Zone, fragments :: [Fragment], scope :: Scope}
    | MenuDisplay {what :: Type, uuid :: UUID, isMenu :: Bool}
    deriving (Generic, Data, Typeable, Show, Eq, Ord)

instance FromJSON Configuration where
    parseJSON :: JSON.Value -> Parser Configuration
    parseJSON = genericParseJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}

instance ToJSON Configuration where
    toJSON :: Configuration -> JSON.Value
    toJSON = genericToJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}
