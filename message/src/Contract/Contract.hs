module Contract.Contract where

import Data.Aeson (FromJSON (..), ToJSON (..), genericParseJSON, genericToJSON)
import Data.Data (Data)
import Data.UUID (UUID)
import GHC.Generics (Generic)
import Json (taggedOptions)
import Type (Type)

data Contract = Contract
    { what :: Type
    , uuid :: UUID
    , type_ :: UUID
    --    , parties:: List Agent
    --    , clauses::
    --    , terms::
    }
    deriving (Generic, Data, Show, Eq, Ord)

instance FromJSON Contract where
    parseJSON = genericParseJSON taggedOptions

instance ToJSON Contract where
    toJSON = genericToJSON taggedOptions
