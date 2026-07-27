module Expression where

import Data.Aeson as JSON
import Data.Aeson.Types (Parser)
import Data.Data (Data, Typeable)
import Expression.Binary as B
import Expression.Observable (Observable)
import Expression.Unary as U
import GHC.Generics (Generic)

data Expression
    = Leaf Observable
    | Unary {uop :: U.Operator, expr :: Expression}
    | Binary {bop :: B.Operator, expr1 :: Expression, expr2 :: Expression}
    deriving (Generic, Data, Typeable, Show, Eq, Ord)

instance FromJSON Expression where
    parseJSON :: JSON.Value -> Parser Expression
    parseJSON = genericParseJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}

instance ToJSON Expression where
    toJSON :: Expression -> JSON.Value
    toJSON = genericToJSON defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}
