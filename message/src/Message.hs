{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Message where

import Control.Exception (SomeException (SomeException), catch)
import Data.Aeson (FromJSON, ToJSON, parseJSON, toJSON, withObject, (.:))
import Data.Aeson qualified as JSON
import Data.Aeson.Types (Parser)
import Data.ByteString.Char8 qualified as BS
import Data.ByteString.Lazy (fromStrict, toStrict)
import Data.Data (Data (toConstr), Typeable)
import Data.List qualified as List
import Data.Text qualified as T
import Data.Text.Encoding (decodeUtf8)
import Data.Text.IO qualified as IO (appendFile)
import Data.Time.Clock.POSIX (POSIXTime)
import GHC.Generics (Generic)
import Ident.Fragment (Fragment)
import Ident.Identifier (fragments)
import MessageFlow (MessageFlow)
import MessageId (MessageId)
import Metadata (Metadata, flow, from, uuid, when)
import Payload (Payload (..))
import Service (Service)

data Message = Message Metadata Payload
    deriving (Generic, Data, Typeable, Show, Eq, Ord)

instance FromJSON Message where
    parseJSON :: JSON.Value -> Parser Message
    parseJSON value = do
        meta <- (JSON.parseJSON =<< withObject "Metadata" (.: "meta") value) :: Parser Metadata
        payl <- (JSON.parseJSON =<< withObject "Payload" (.: "load") value) :: Parser Payload
        return $ Message meta payl

instance ToJSON Message where
    toJSON :: Message -> JSON.Value
    toJSON (Message m p) = JSON.object [("meta", toJSON m), ("load", toJSON p)]

payload :: Message -> Payload
payload (Message _ p) = p

metadata :: Message -> Metadata
metadata (Message m _) = m

messageId :: Message -> MessageId
messageId (Message m _) = (uuid m, flow m)

isType :: Message -> T.Text -> Bool
isType (Message _ p) t = t == T.pack (show $ toConstr p)

excludeType :: T.Text -> [Message] -> [Message]
excludeType t = filter (not . (`isType` t))

isAfter :: POSIXTime -> Message -> Bool
isAfter t msg = when (metadata msg) > t

getFlow :: Message -> MessageFlow
getFlow = flow . metadata

setFlow :: MessageFlow -> Message -> Message
setFlow flow (Message m p) = Message m{flow = flow} p

setCreator :: Service -> Message -> Message
setCreator origin (Message m p) = Message m{from = List.singleton origin} p

creator :: Message -> Service
creator = head . from . metadata -- maybe reconsider NonEmpty

addVisited :: Service -> Message -> Message
addVisited origin (Message m p) = Message m{from = from m ++ [origin]} p

dropLastVisited :: Message -> Message
dropLastVisited (Message m p) = Message m{from = reverse $ drop 1 $ reverse $ from m} p

lastVisited :: Message -> Service
lastVisited = last . from . metadata -- maybe reconsider NonEmpty

appendMessage :: FilePath -> Message -> IO ()
appendMessage f msg = do
    -- TODO use decodeUtf8' to avoid errors
    IO.appendFile f $! decodeUtf8 (toStrict $ JSON.encode msg) `T.append` "\n"
    putStrLn "Message stored"

-- read the message store
readMessages :: FilePath -> IO [Message]
readMessages f =
    do
        es <- catch (BS.readFile f) handleError
        case mapM JSON.eitherDecode $ fromStrict <$> BS.lines es of
            Right evs -> return evs
            Left err -> do
                putStrLn err
                return []
  where
    handleError :: SomeException -> IO BS.ByteString
    handleError (SomeException _) = do
        putStrLn "Could not read MessageSource"
        return ""

getFragments :: Message -> [Fragment]
getFragments (Message _ p) = case p of
    AddedIdentifier i -> fragments i
    _ -> []

setFragments :: [Fragment] -> Message -> Message
setFragments fragments (Message m p) = case p of
    AddedIdentifier i -> Message m $ AddedIdentifier i{fragments = fragments}
    _ -> Message m p
