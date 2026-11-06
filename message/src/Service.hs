module Service (Service (..)) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericParseJSON, genericToJSON)
import Data.Data (Data)
import GHC.Generics (Generic)
import Json (taggedOptions)

{-
type MessageType = String
type ServiceRole = String

type ServiceRegistry =
    -- The list of services, and the messages accepted by each service
    Map MessageType (Set ServiceRole)

recipients :: Message -> ServiceRegistry -> Set ServiceRole
recipients m sr = fromMaybe Set.empty $ Map.lookup (show $ toConstr $ payload m) sr
-}

data Service
    = None -- find a way to initialize an undefined MVar
    | Front
    | Studio
    | Dumb
    | Store
    | Ident
    deriving (Generic, Data, Show, Eq, Ord)

instance FromJSON Service where
    parseJSON = genericParseJSON taggedOptions

instance ToJSON Service where
    toJSON = genericToJSON taggedOptions
