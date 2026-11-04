module CommitmentType.CommitmentType where

import Data.Aeson (FromJSON (..), ToJSON (..), genericParseJSON, genericToJSON)
import Data.Data (Data)
import Data.UUID (UUID)
import Expression (Expression)
import GHC.Generics (Generic)
import Json (taggedOptions)
import Scope (Scope)
import Type (Type)

data CommitmentType = CommitmentType
    { what :: Type
    , uuid :: UUID
    , parent :: Maybe UUID
    , providers :: Scope
    , receivers :: Scope
    , flowscope :: Scope
    , qty :: Expression
    }
    deriving (Generic, Data, Show, Eq, Ord)

instance FromJSON CommitmentType where
    parseJSON = genericParseJSON taggedOptions

instance ToJSON CommitmentType where
    toJSON = genericToJSON taggedOptions
