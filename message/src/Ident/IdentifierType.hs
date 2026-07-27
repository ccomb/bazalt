module Ident.IdentifierType where

import Data.Aeson as JSON
import Data.Aeson.Types (Parser)
import Data.Data (Data, Typeable)
import Data.Text (Text)
import GHC.Generics (Generic)
import Ident.Fragment (Fragment)
import Scope (Scope)

data IdentifierType = IdentifierType
    -- This is the definition of an identifier
    { name :: Text
    , fragments :: [Fragment]
    , scope :: Scope
    , unique :: Bool
    , mandatory :: Bool
    }
    deriving (Generic, Data, Typeable, Show, Eq, Ord)

instance FromJSON IdentifierType where
    parseJSON :: JSON.Value -> Parser IdentifierType
    parseJSON = genericParseJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}

instance ToJSON IdentifierType where
    toJSON :: IdentifierType -> JSON.Value
    toJSON = genericToJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}
