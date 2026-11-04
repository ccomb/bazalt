module Calendar (Month (..), Weekday (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericParseJSON, genericToJSON)
import Data.Data (Data)
import GHC.Generics (Generic)
import Json (taggedOptions)

-- | A month of the year, whatever the year.
data Month = Jan | Feb | Mar | Apr | May | Jun | Jul | Aug | Sep | Oct | Nov | Dec
    deriving (Generic, Data, Show, Eq, Ord, Enum, Bounded)

-- | A day of the week.
data Weekday = Mon | Tue | Wed | Thu | Fri | Sat | Sun
    deriving (Generic, Data, Show, Eq, Ord, Enum, Bounded)

instance FromJSON Month where
    parseJSON = genericParseJSON taggedOptions

instance ToJSON Month where
    toJSON = genericToJSON taggedOptions

instance FromJSON Weekday where
    parseJSON = genericParseJSON taggedOptions

instance ToJSON Weekday where
    toJSON = genericToJSON taggedOptions
