module Process.Reconcile where

import Data.Aeson (FromJSON (..), ToJSON (..), genericParseJSON, genericToJSON)
import Data.Data (Data)
import Data.UUID (UUID)
import GHC.Generics (Generic)
import Json (taggedOptions)

data Reconciliation = Reconciliation
    -- a Reconciliation is link between a Process (ie an activity) and a partial Event
    -- TODO use newtype style Uuids (phantom type): type Event = Event Uuid
    { qty :: Rational
    , event :: UUID
    , process :: UUID
    }
    deriving (Generic, Data, Show, Eq, Ord)

instance FromJSON Reconciliation where
    parseJSON = genericParseJSON taggedOptions

instance ToJSON Reconciliation where
    toJSON = genericToJSON taggedOptions
