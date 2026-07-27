module Ident.Fragment (Fragment (..)) where

import Data.Aeson as JSON (FromJSON, Options (sumEncoding), ToJSON, Value (..), defaultOptions, genericParseJSON, genericToJSON, parseJSON, toJSON)
import Data.Aeson.Types (Parser, SumEncoding (..))
import Data.Data (Data, Typeable)
import Data.Text (Text)
import Data.Time.Calendar.Month (Month (..))
import Data.Time.Calendar.WeekDate (DayOfWeek (..))
import Data.Time.Clock.POSIX (POSIXTime)
import GHC.Generics

data Fragment
    = Free Text
    | Fixed Text
    | Sequence {name :: Text, padding :: Int, step :: Int, start :: Int, val :: Maybe Int}
    | Existing {name :: Text, value :: Text}
    | YYYY Int
    | YY Int
    | MMMM Month
    | MM Month
    | Weekday DayOfWeek
    | DoM Int
    | Hour Int
    | Minute Int
    | Second Int
    | DateFrom {field :: Text, when :: POSIXTime}
    deriving (Generic, Data, Typeable, Show, Eq, Ord)

instance FromJSON Fragment where
    parseJSON :: JSON.Value -> Parser Fragment
    parseJSON = genericParseJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}

instance ToJSON Fragment where
    toJSON :: Fragment -> JSON.Value
    toJSON = genericToJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}
