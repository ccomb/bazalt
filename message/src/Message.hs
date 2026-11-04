{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE OverloadedStrings #-}

module Message where

import Control.Exception (IOException, try)
import Data.Aeson (FromJSON, ToJSON, parseJSON, toJSON, withObject, (.:))
import Data.Aeson qualified as JSON
import Data.Aeson.Types (Parser)
import Data.Bifunctor (first)
import Data.ByteString.Char8 qualified as BS
import Data.ByteString.Lazy (toStrict)
import Data.Data (Data (toConstr))
import Data.List qualified as List
import Data.Maybe (fromMaybe, listToMaybe)
import Data.Text qualified as T
import Data.Text.Encoding (decodeUtf8)
import Data.Text.IO qualified as IO (appendFile)
import Data.Text.IO qualified as TIO
import Data.Time.Clock.POSIX (POSIXTime)
import GHC.Generics (Generic)
import Ident.Fragment (Fragment)
import Ident.Identifier (fragments)
import MessageFlow (MessageFlow)
import MessageId (MessageId)
import Metadata (Metadata, flow, from, uuid, when)
import Payload (Payload (..))
import Service (Service (None))
import System.Directory (doesFileExist)
import System.Exit (exitFailure)
import System.IO (stderr)

data Message = Message Metadata Payload
    deriving (Generic, Data, Show, Eq, Ord)

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
creator = fromMaybe None . listToMaybe . from . metadata

addVisited :: Service -> Message -> Message
addVisited origin (Message m p) = Message m{from = from m ++ [origin]} p

dropLastVisited :: Message -> Message
dropLastVisited (Message m p) = Message m{from = reverse $ drop 1 $ reverse $ from m} p

lastVisited :: Message -> Service
lastVisited = fromMaybe None . listToMaybe . reverse . from . metadata

appendMessage :: FilePath -> Message -> IO ()
appendMessage f msg = do
    -- TODO use decodeUtf8' to avoid errors
    IO.appendFile f $! decodeUtf8 (toStrict $ JSON.encode msg) `T.append` "\n"
    putStrLn "Message stored"

{- | Why a journal cannot be replayed. A service never starts on a partial
journal: it would rebuild a state that silently misses facts.
-}
data JournalError
    = Unreadable FilePath T.Text
    | BadLine FilePath Int T.Text
    deriving (Eq, Show)

describeJournalError :: JournalError -> T.Text
describeJournalError = \case
    Unreadable f err -> T.pack f <> ": unreadable journal: " <> err
    BadLine f n err -> T.pack f <> ", line " <> T.pack (show n) <> ": " <> err

-- | Read the whole journal. A missing file is an empty journal.
readMessages :: FilePath -> IO (Either JournalError [Message])
readMessages f = do
    exists <- doesFileExist f
    if exists
        then either (Left . Unreadable f . T.pack . show) (parseJournal f) <$> try @IOException (BS.readFile f)
        else pure (Right [])

parseJournal :: FilePath -> BS.ByteString -> Either JournalError [Message]
parseJournal f = traverse decodeLine . zip [1 ..] . BS.lines
  where
    decodeLine (n, l) = first (BadLine f n . T.pack) $ JSON.eitherDecodeStrict l

-- | Read the journal at boot, or stop the service, naming the faulty line.
loadJournal :: FilePath -> IO [Message]
loadJournal f = readMessages f >>= either (\err -> TIO.hPutStrLn stderr (describeJournalError err) >> exitFailure) pure

getFragments :: Message -> [Fragment]
getFragments (Message _ p) = case p of
    AddedIdentifier i -> fragments i
    _ -> []

setFragments :: [Fragment] -> Message -> Message
setFragments fragments (Message m p) = case p of
    AddedIdentifier i -> Message m $ AddedIdentifier i{fragments = fragments}
    _ -> Message m p
