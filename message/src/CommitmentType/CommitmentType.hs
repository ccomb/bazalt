module CommitmentType.CommitmentType where

import Data.Aeson as JSON
import Data.Aeson.Types (Parser)
import Data.Data (Data, Typeable)
import Data.UUID (UUID)
import Expression (Expression)
import GHC.Generics (Generic)
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
    deriving (Generic, Data, Typeable, Show, Eq, Ord)

instance FromJSON CommitmentType where
    parseJSON :: JSON.Value -> Parser CommitmentType
    parseJSON = genericParseJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}

instance ToJSON CommitmentType where
    toJSON :: CommitmentType -> JSON.Value
    toJSON = genericToJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}
