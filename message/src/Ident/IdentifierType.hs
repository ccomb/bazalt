module Ident.IdentifierType where

import Data.Aeson (FromJSON (..), ToJSON (..), genericParseJSON, genericToJSON)
import Data.Data (Data)
import Data.Text (Text)
import GHC.Generics (Generic)
import Ident.Fragment (Fragment)
import Json (taggedOptions)
import Scope (Scope)

data IdentifierType = IdentifierType
    -- This is the definition of an identifier
    { name :: Text
    , fragments :: [Fragment]
    , scope :: Scope
    , unique :: Bool
    , mandatory :: Bool
    }
    deriving (Generic, Data, Show, Eq, Ord)

instance FromJSON IdentifierType where
    parseJSON = genericParseJSON taggedOptions

instance ToJSON IdentifierType where
    toJSON = genericToJSON taggedOptions
