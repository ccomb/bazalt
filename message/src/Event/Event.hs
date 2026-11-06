module Event.Event where

import Data.Aeson (FromJSON (..), ToJSON (..), genericParseJSON, genericToJSON)
import Data.Data (Data)
import Data.Time.Clock.POSIX (POSIXTime)
import Data.UUID (UUID)
import Expression (Expression)
import Flow (Flow)
import GHC.Generics (Generic)
import Json (taggedOptions)
import Typed.Type qualified as TType

data Event = Event
    { what :: TType.Type
    , uuid :: UUID
    , when :: POSIXTime
    , qty :: Expression
    , type_ :: UUID
    , provider :: UUID
    , receiver :: UUID
    , flow :: Flow
    }
    deriving (Generic, Data, Show, Eq, Ord)

instance FromJSON Event where
    parseJSON = genericParseJSON taggedOptions

instance ToJSON Event where
    toJSON = genericToJSON taggedOptions
