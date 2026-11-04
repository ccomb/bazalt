module ProcessType.ProcessType where

import Data.Aeson (FromJSON (..), ToJSON (..), genericParseJSON, genericToJSON)
import Data.Data (Data)
import Data.Set (Set)
import Data.UUID (UUID)
import GHC.Generics (Generic)
import Json (taggedOptions)
import Hierarchy.Type qualified as HType

data ProcessType = ProcessType
    { what :: HType.Type
    , uuid :: UUID
    , parent :: Maybe UUID
    , eventTypes :: Set UUID
    }
    deriving (Generic, Data, Show, Eq, Ord)

instance FromJSON ProcessType where
    parseJSON = genericParseJSON taggedOptions

instance ToJSON ProcessType where
    toJSON = genericToJSON taggedOptions
