module Resource.Resource where

import Data.Aeson (FromJSON (..), ToJSON (..), genericParseJSON, genericToJSON)
import Data.Data (Data)
import Data.UUID (UUID)
import GHC.Generics (Generic)
import Json (taggedOptions)
import Type (Type)

data Resource = Resource
    { what :: Type
    , uuid :: UUID
    , type_ :: UUID
    , qty :: Rational
    }
    deriving (Generic, Data, Show, Eq, Ord)

instance FromJSON Resource where
    parseJSON = genericParseJSON taggedOptions

instance ToJSON Resource where
    toJSON = genericToJSON taggedOptions
