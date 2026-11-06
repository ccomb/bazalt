module Ident.Identifier where

import Data.Aeson (FromJSON (..), ToJSON (..), genericParseJSON, genericToJSON)
import Data.Data (Data)
import Data.Text (Text)
import Data.UUID (UUID)
import GHC.Generics (Generic)
import Ident.Fragment (Fragment)
import Json (taggedOptions)
import Type (Type)

data Identifier = Identifier
    { what :: Type
    , for :: UUID
    , name :: Text
    , fragments :: [Fragment]
    }
    deriving (Generic, Data, Show, Eq, Ord)

instance FromJSON Identifier where
    parseJSON = genericParseJSON taggedOptions

instance ToJSON Identifier where
    toJSON = genericToJSON taggedOptions
