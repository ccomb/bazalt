module Connection (Connection (..)) where

import Data.Aeson as JSON
import Data.Aeson.Types (Parser)
import Data.Data (Data, Typeable)
import Data.Set as Set (Set)
import Data.Time.Clock.POSIX (POSIXTime)
import GHC.Generics (Generic)
import MessageId (MessageId)

data Connection = Connection
    { lastMessageTime :: POSIXTime
    , uuids :: Set MessageId
    }
    deriving (Generic, Data, Typeable, Show, Eq, Ord)

instance FromJSON Connection where
    parseJSON :: JSON.Value -> Parser Connection
    parseJSON = genericParseJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}

instance ToJSON Connection where
    toJSON :: Connection -> JSON.Value
    toJSON = genericToJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}
