module Value.ValueType where

import Data.Aeson (FromJSON (..), ToJSON (..), genericParseJSON, genericToJSON)
import Data.Data (Data)
import Data.Text (Text)
import Expression (Expression)
import GHC.Generics (Generic)
import Json (taggedOptions)
import Scope (Scope)

data ValueType = ValueType
    -- this is the definition of a value field
    { name :: Text
    , expr :: Expression
    , scope :: Scope
    , mandatory :: Bool
    }
    deriving (Generic, Data, Show, Eq, Ord)

instance FromJSON ValueType where
    parseJSON = genericParseJSON taggedOptions

instance ToJSON ValueType where
    toJSON = genericToJSON taggedOptions
