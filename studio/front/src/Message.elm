port module Message exposing (compare, getTime, messageId, readMessages, renewSeed, storeMessages, storeMessagesToSend)

import Json.Encode as Encode
import MessageId exposing (MessageId)
import Ontology.Message exposing (Message)
import Ontology.Metadata exposing (Metadata)
import Prng.Uuid as Uuid
import Time exposing (posixToMillis)



-- read messages from IDB


port readMessages : Encode.Value -> Cmd msg



-- store messages to IDB then send to WS


port storeMessages : Encode.Value -> Cmd msg



-- only store to IDB


port storeMessagesToSend : Encode.Value -> Cmd msg


port renewSeed : () -> Cmd msg



-- application/user messages --


messageId : Message -> MessageId
messageId =
    base >> (\m -> ( m.uuid, m.flow ))


base : Message -> Metadata
base =
    .meta


compare : Message -> String
compare message =
    let
        m =
            message.meta
    in
    -- TODO what if 2 messages at the exact same time?
    -- => also use a session uuid
    -- TODO : use UUID instead? see updatePending
    (m.when |> posixToMillis |> String.fromInt) ++ ":" ++ Uuid.toString m.uuid


getTime : Message -> Time.Posix
getTime =
    base >> .when



-- JSON encoding / decoding
