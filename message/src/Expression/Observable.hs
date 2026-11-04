module Expression.Observable where

import Data.Aeson (FromJSON (..), ToJSON (..), genericParseJSON, genericToJSON)
import Data.Data (Data)
import Data.Text as T
import Expression.Deeplink as Deeplink (DeepLink)
import Expression.ValueSelection (ValueSelection)
import GHC.Generics (Generic)
import Json (taggedOptions)

data Observable
    = Constant T.Text
    | Variable {name :: T.Text, input :: T.Text}
    | ObsValue ValueSelection
    | ObsLink DeepLink
    deriving (Generic, Data, Show, Eq, Ord)

instance FromJSON Observable where
    parseJSON = genericParseJSON taggedOptions

instance ToJSON Observable where
    toJSON = genericToJSON taggedOptions
