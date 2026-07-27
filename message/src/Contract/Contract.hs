module Contract.Contract where

import Data.Aeson as JSON
import Data.Aeson.Types (Parser)
import Data.Data (Data, Typeable)
import Data.UUID (UUID)
import GHC.Generics (Generic)
import Type (Type)

data Contract = Contract
    { what :: Type
    , uuid :: UUID
    , type_ :: UUID
    --    , parties:: List Agent
    --    , clauses::
    --    , terms::
    }
    deriving (Generic, Data, Typeable, Show, Eq, Ord)

instance FromJSON Contract where
    parseJSON :: JSON.Value -> Parser Contract
    parseJSON = genericParseJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}

instance ToJSON Contract where
    toJSON :: Contract -> JSON.Value
    toJSON = genericToJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}
