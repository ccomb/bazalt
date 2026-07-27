module Service (Service (..)) where

import Data.Aeson as JSON
import Data.Aeson.Types (Parser)
import Data.Data (Data, Typeable)
import Data.Text qualified as T
import GHC.Generics (Generic)

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
    deriving (Generic, Data, Typeable, Show, Eq, Ord)

instance FromJSON Service where
    parseJSON :: JSON.Value -> Parser Service
    parseJSON = genericParseJSON defaultOptions{sumEncoding = UntaggedValue}

instance ToJSON Service where
    toJSON :: Service -> JSON.Value
    toJSON = JSON.String . T.pack . show
