{-# LANGUAGE DeriveGeneric #-}

module Metadata where

import Data.Aeson (FromJSON (..), ToJSON (..), genericParseJSON, genericToJSON)
import Data.Data (Data)
import Data.Time.Clock.POSIX (POSIXTime)
import Data.UUID (UUID)
import GHC.Generics (Generic)
import Json (taggedOptions)
import MessageFlow
import Service (Service)

data Metadata = Metadata
    { uuid :: UUID
    , when :: POSIXTime
    , from :: [Service]
    , flow :: MessageFlow
    }
    deriving (Generic, Data, Show, Eq, Ord)

instance FromJSON Metadata where
    parseJSON = genericParseJSON taggedOptions

instance ToJSON Metadata where
    toJSON = genericToJSON taggedOptions
