module Commitment.Commitment where

import Data.Aeson as JSON
import Data.Aeson.Types (Parser)
import Data.Data (Data, Typeable)
import Data.Time.Clock.POSIX (POSIXTime)
import Data.UUID (UUID)
import Expression (Expression)
import Flow (Flow)
import GHC.Generics (Generic)
import Type (Type)

data Commitment = Commitment
    { what :: Type
    , uuid :: UUID
    , when :: POSIXTime
    , qty :: Expression
    , type_ :: UUID
    , provider :: UUID
    , receiver :: UUID
    , flow :: Flow
    }
    deriving (Generic, Data, Typeable, Show, Eq, Ord)

instance FromJSON Commitment where
    parseJSON :: JSON.Value -> Parser Commitment
    parseJSON = genericParseJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}

instance ToJSON Commitment where
    toJSON :: Commitment -> JSON.Value
    toJSON = genericToJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}
