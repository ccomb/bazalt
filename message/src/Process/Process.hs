module Process.Process where

import Data.Aeson (FromJSON (..), ToJSON (..), genericParseJSON, genericToJSON)
import Data.Data (Data)
import Data.UUID (UUID)
import GHC.Generics (Generic)
import Json (taggedOptions)
import Typed.Type qualified as TType

data Process = Process
    { what :: TType.Type
    , uuid :: UUID
    , type_ :: UUID
    }
    deriving (Generic, Data, Show, Eq, Ord)

instance FromJSON Process where
    parseJSON = genericParseJSON taggedOptions

instance ToJSON Process where
    toJSON = genericToJSON taggedOptions
