module Connection (Connection (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericParseJSON, genericToJSON)
import Data.Data (Data)
import Data.Set as Set (Set)
import Data.Time.Clock.POSIX (POSIXTime)
import GHC.Generics (Generic)
import Json (taggedOptions)
import MessageId (MessageId)

data Connection = Connection
    { lastMessageTime :: POSIXTime
    , uuids :: Set MessageId
    }
    deriving (Generic, Data, Show, Eq, Ord)

instance FromJSON Connection where
    parseJSON = genericParseJSON taggedOptions

instance ToJSON Connection where
    toJSON = genericToJSON taggedOptions
