module Type (Type (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericParseJSON, genericToJSON)
import Data.Data (Data)
import GHC.Generics (Generic)
import Hierarchy.Type qualified as HType
import Json (taggedOptions)
import Typed.Type qualified as TType

-- | The kind of anything the configuration can point at: an entity or a type.
data Type
    = TType TType.Type
    | HType HType.Type
    deriving (Generic, Data, Show, Eq, Ord)

instance FromJSON Type where
    parseJSON = genericParseJSON taggedOptions

instance ToJSON Type where
    toJSON = genericToJSON taggedOptions
