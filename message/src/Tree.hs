module Tree where

import Data.Aeson as JSON
import Data.Aeson.Types (Parser)
import Data.Data (Data, Typeable)
import GHC.Generics (Generic)

data TreeType
    = -- non hierarchical group (or any tree-like structure)
      Flat
    | -- hierarchical and node-selectable
      Node
    | -- hierarchical and leaf-selectable
      Leaf
    deriving (Generic, Data, Typeable, Show, Eq, Ord)

instance FromJSON TreeType where
    parseJSON :: JSON.Value -> Parser TreeType
    parseJSON = genericParseJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}

instance ToJSON TreeType where
    toJSON :: TreeType -> JSON.Value
    toJSON = genericToJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}
