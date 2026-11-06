module Ontology.Metadata exposing
    ( Metadata
    , metadataDecoder
    , metadataEncoder
    )

import Json.Decode
import Json.Decode.Pipeline
import Json.Encode
import Ontology.MessageFlow
import Ontology.Prim
import Ontology.Service
import Prng.Uuid
import Time


type alias Metadata =
    { uuid : Prng.Uuid.Uuid
    , when : Time.Posix
    , from : List Ontology.Service.Service
    , flow : Ontology.MessageFlow.MessageFlow
    }


metadataEncoder : Metadata -> Json.Encode.Value
metadataEncoder a =
    Json.Encode.object
        [ ( "uuid", Prng.Uuid.encode a.uuid )
        , ( "when", Ontology.Prim.posixEncoder a.when )
        , ( "from", Json.Encode.list Ontology.Service.serviceEncoder a.from )
        , ( "flow", Ontology.MessageFlow.messageFlowEncoder a.flow )
        ]


metadataDecoder : Json.Decode.Decoder Metadata
metadataDecoder =
    Json.Decode.succeed Metadata
        |> Json.Decode.Pipeline.required "uuid" Prng.Uuid.decoder
        |> Json.Decode.Pipeline.required "when" Ontology.Prim.posixDecoder
        |> Json.Decode.Pipeline.required "from" (Json.Decode.list Ontology.Service.serviceDecoder)
        |> Json.Decode.Pipeline.required "flow" Ontology.MessageFlow.messageFlowDecoder
