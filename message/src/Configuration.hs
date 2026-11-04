module Configuration where

import Configuration.Zone (Zone)
import Data.Aeson (FromJSON (..), ToJSON (..), genericParseJSON, genericToJSON)
import Json (taggedOptions)

import Configuration.Zone.Fragment (Fragment)
import Data.Data (Data)
import Data.UUID (UUID)
import GHC.Generics (Generic)
import Scope (Scope)
import Type (Type)

data Configuration
    = -- the list of identifier types to display on each zone
      ZoneDisplay {zone :: Zone, fragments :: [Fragment], scope :: Scope}
    | MenuDisplay {what :: Type, uuid :: UUID, isMenu :: Bool}
    deriving (Generic, Data, Show, Eq, Ord)

instance FromJSON Configuration where
    parseJSON = genericParseJSON taggedOptions

instance ToJSON Configuration where
    toJSON = genericToJSON taggedOptions
