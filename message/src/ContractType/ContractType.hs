module ContractType.ContractType where

import Data.Aeson (FromJSON (..), ToJSON (..), genericParseJSON, genericToJSON)
import Data.Data (Data)
import Data.UUID (UUID)
import GHC.Generics (Generic)
import Json (taggedOptions)
import Type (Type)

data ContractType = ContractType
    { what :: Type
    , uuid :: UUID
    , parent :: Maybe UUID
    }
    deriving (Generic, Data, Show, Eq, Ord)

instance FromJSON ContractType where
    parseJSON = genericParseJSON taggedOptions

instance ToJSON ContractType where
    toJSON = genericToJSON taggedOptions
