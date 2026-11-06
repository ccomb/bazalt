module Expression where

import Data.Aeson (FromJSON (..), ToJSON (..), genericParseJSON, genericToJSON)
import Data.Data (Data)
import Expression.Binary as B
import Expression.Observable (Observable)
import Expression.Unary as U
import GHC.Generics (Generic)
import Json (taggedOptions)

data Expression
    = Leaf Observable
    | Unary {uop :: U.Operator, expr :: Expression}
    | Binary {bop :: B.Operator, expr1 :: Expression, expr2 :: Expression}
    deriving (Generic, Data, Show, Eq, Ord)

instance FromJSON Expression where
    parseJSON = genericParseJSON taggedOptions

instance ToJSON Expression where
    toJSON = genericToJSON taggedOptions
