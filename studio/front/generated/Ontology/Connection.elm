module Ontology.Connection exposing
    ( Connection
    , connectionDecoder
    , connectionEncoder
    )

import Json.Decode
import Json.Decode.Pipeline
import Json.Encode
import Ontology.MessageFlow
import Ontology.Prim
import Prng.Uuid
import Time


type alias Connection =
    { lastMessageTime : Time.Posix
    , uuids : List ( Prng.Uuid.Uuid, Ontology.MessageFlow.MessageFlow )
    }


connectionEncoder : Connection -> Json.Encode.Value
connectionEncoder a =
    Json.Encode.object
        [ ( "lastMessageTime", Ontology.Prim.posixEncoder a.lastMessageTime )
        , ( "uuids"
          , Json.Encode.list
                (\b ->
                    case b of
                        ( c, d ) ->
                            Json.Encode.list identity
                                [ Prng.Uuid.encode c
                                , Ontology.MessageFlow.messageFlowEncoder d
                                ]
                )
                a.uuids
          )
        ]


connectionDecoder : Json.Decode.Decoder Connection
connectionDecoder =
    Json.Decode.succeed Connection
        |> Json.Decode.Pipeline.required "lastMessageTime" Ontology.Prim.posixDecoder
        |> Json.Decode.Pipeline.required "uuids" (Json.Decode.list (Json.Decode.map2 Tuple.pair (Json.Decode.index 0 Prng.Uuid.decoder) (Json.Decode.index 1 Ontology.MessageFlow.messageFlowDecoder)))
