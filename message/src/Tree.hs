module Tree where

import Data.Aeson (FromJSON (..), ToJSON (..), genericParseJSON, genericToJSON)
import Data.Data (Data)
import GHC.Generics (Generic)
import Json (taggedOptions)

data TreeType
    = -- non hierarchical group (or any tree-like structure)
      Flat
    | -- hierarchical and node-selectable
      Node
    | -- hierarchical and leaf-selectable
      Leaf
    deriving (Generic, Data, Show, Eq, Ord)

instance FromJSON TreeType where
    parseJSON = genericParseJSON taggedOptions

instance ToJSON TreeType where
    toJSON = genericToJSON taggedOptions
