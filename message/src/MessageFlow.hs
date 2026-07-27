module MessageFlow where

import Data.Aeson as JSON
import Data.Aeson.Types (Parser)
import Data.Data (Data, Typeable)
import Data.Text (Text)
import GHC.Generics (Generic)

data MessageFlow
    = Requested
    | Processed
    | Error Text
    deriving (Eq, Generic, Data, Typeable, Ord, Show)

instance FromJSON MessageFlow where
    parseJSON :: Value -> Parser MessageFlow
    parseJSON = genericParseJSON defaultOptions{sumEncoding = UntaggedValue}

instance ToJSON MessageFlow where
    toJSON :: MessageFlow -> Value
    toJSON = genericToJSON defaultOptions{sumEncoding = UntaggedValue}
