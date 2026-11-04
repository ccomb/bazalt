module Agent.Agent where

import Data.Aeson (FromJSON (..), ToJSON (..), genericParseJSON, genericToJSON)
import Data.Data (Data)
import Data.UUID (UUID)
import GHC.Generics (Generic)
import Json (taggedOptions)
import Typed.Type qualified as TType

data Agent = Agent
    { what :: TType.Type
    , uuid :: UUID
    , type_ :: UUID
    }
    deriving (Generic, Data, Show, Eq, Ord)

instance FromJSON Agent where
    parseJSON = genericParseJSON taggedOptions

instance ToJSON Agent where
    toJSON = genericToJSON taggedOptions
