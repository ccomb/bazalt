module Ident.Fragment (Fragment (..)) where

import Calendar (Month, Weekday)
import Data.Aeson (FromJSON (..), ToJSON (..), genericParseJSON, genericToJSON)
import Data.Data (Data)
import Data.Text (Text)
import Data.Time.Clock.POSIX (POSIXTime)
import GHC.Generics
import Json (taggedOptions)

data Fragment
    = Free Text
    | Fixed Text
    | Sequence {name :: Text, padding :: Int, step :: Int, start :: Int, val :: Maybe Int}
    | Existing {name :: Text, value :: Text}
    | YYYY Int
    | YY Int
    | MMMM Month
    | MM Month
    | Weekday Weekday
    | DoM Int
    | Hour Int
    | Minute Int
    | Second Int
    | DateFrom {field :: Text, when :: POSIXTime}
    deriving (Generic, Data, Show, Eq, Ord)

instance FromJSON Fragment where
    parseJSON = genericParseJSON taggedOptions

instance ToJSON Fragment where
    toJSON = genericToJSON taggedOptions
