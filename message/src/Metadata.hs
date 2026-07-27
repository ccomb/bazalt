{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Metadata where

import Data.Aeson (FromJSON, Options (sumEncoding), ToJSON, defaultOptions, genericParseJSON, genericToJSON, parseJSON, toJSON)
import Data.Aeson qualified as JSON
import Data.Aeson.Types (Parser, SumEncoding (..))
import Data.Data (Data, Typeable)
import Data.Time.Clock.POSIX (POSIXTime)
import Data.UUID (UUID)
import GHC.Generics (Generic)
import MessageFlow
import Service (Service)

data Metadata = Metadata
    { uuid :: UUID
    , when :: POSIXTime
    , from :: [Service]
    , flow :: MessageFlow
    }
    deriving (Generic, Data, Typeable, Show, Eq, Ord)

instance FromJSON Metadata where
    parseJSON :: JSON.Value -> Parser Metadata
    parseJSON = genericParseJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}

instance ToJSON Metadata where
    toJSON :: Metadata -> JSON.Value
    toJSON = genericToJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}
