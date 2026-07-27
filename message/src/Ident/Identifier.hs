module Ident.Identifier where

import Data.Aeson as JSON
import Data.Aeson.Types (Parser)
import Data.Data (Data, Typeable)
import Data.UUID (UUID)
import GHC.Generics (Generic)
import Ident.Fragment (Fragment)
import Type (Type)

data Identifier = Identifier
    { what :: Type
    , for :: UUID
    , name :: String
    , fragments :: [Fragment]
    }
    deriving (Generic, Data, Typeable, Show, Eq, Ord)

instance FromJSON Identifier where
    parseJSON :: JSON.Value -> Parser Identifier
    parseJSON = genericParseJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}

instance ToJSON Identifier where
    toJSON :: Identifier -> JSON.Value
    toJSON = genericToJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}
