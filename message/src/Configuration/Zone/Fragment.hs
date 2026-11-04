module Configuration.Zone.Fragment where

import Data.Aeson (FromJSON (..), ToJSON (..), genericParseJSON, genericToJSON)
import Data.Data (Data)
import Data.Text (Text)
import GHC.Generics (Generic)
import Json (taggedOptions)
import Scope

type Name = Text
type Separator = Text

data Fragment
    = -- TODO: add Types to be able to display the type in the zone
      IdentifierName {name :: Name}
    | GroupIdentifierName {scope :: Scope, name :: Name {- to display the name of a group of the entity -}}
    | Parent
    | Fixed {string :: Name}
    | Quantity
    | Flow
    | Provider
    | Receiver
    | EventList {qtySep :: Separator, eventSep :: Separator}
    deriving (Eq, Generic, Data, Ord, Show)

instance FromJSON Fragment where
    parseJSON = genericParseJSON taggedOptions

instance ToJSON Fragment where
    toJSON = genericToJSON taggedOptions
