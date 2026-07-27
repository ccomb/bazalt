module Expression.Observable where

import Data.Aeson as JSON
import Data.Aeson.Types (Parser)
import Data.Data (Data, Typeable)
import Data.Text as T
import Expression.Deeplink as Deeplink (DeepLink)
import Expression.ValueSelection (ValueSelection)
import GHC.Generics (Generic)

data Observable
    = Constant Rational
    | Variable {name :: T.Text, input :: T.Text}
    | ObsValue ValueSelection
    | ObsLink DeepLink
    deriving (Generic, Data, Typeable, Show, Eq, Ord)

instance FromJSON Observable where
    parseJSON :: JSON.Value -> Parser Observable
    parseJSON = genericParseJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}

instance ToJSON Observable where
    toJSON :: Observable -> JSON.Value
    toJSON = genericToJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}
