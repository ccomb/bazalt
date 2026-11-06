module Expression.Unary where

import Data.Aeson (FromJSON (..), ToJSON (..), genericParseJSON, genericToJSON)
import Data.Data (Data)
import GHC.Generics (Generic)
import Json (taggedOptions)

data Operator
    = Neg
    | Inv
    deriving (Generic, Data, Show, Eq, Ord)

instance FromJSON Operator where
    parseJSON = genericParseJSON taggedOptions

instance ToJSON Operator where
    toJSON = genericToJSON taggedOptions
