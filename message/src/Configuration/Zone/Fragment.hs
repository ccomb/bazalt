module Configuration.Zone.Fragment where

import Data.Aeson as JSON
import Data.Aeson.Types (Parser)
import Data.Data (Data, Typeable)
import Data.Text (Text)
import GHC.Generics (Generic)
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
    deriving (Eq, Generic, Data, Typeable, Ord, Show)

instance FromJSON Fragment where
    parseJSON :: Value -> Parser Fragment
    parseJSON = genericParseJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}

instance ToJSON Fragment where
    toJSON :: Fragment -> Value
    toJSON = genericToJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}
