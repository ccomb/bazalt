module Ontology.ProcessType.ProcessType exposing
    ( ProcessType
    , processTypeDecoder
    , processTypeEncoder
    )

import Json.Decode
import Json.Decode.Pipeline
import Json.Encode
import Maybe.Extra
import Ontology.Hierarchy.Type
import Prng.Uuid


type alias ProcessType =
    { what : Ontology.Hierarchy.Type.Type
    , uuid : Prng.Uuid.Uuid
    , parent : Maybe Prng.Uuid.Uuid
    , eventTypes : List Prng.Uuid.Uuid
    }


processTypeEncoder : ProcessType -> Json.Encode.Value
processTypeEncoder a =
    Json.Encode.object
        [ ( "what", Ontology.Hierarchy.Type.typeEncoder a.what )
        , ( "uuid", Prng.Uuid.encode a.uuid )
        , ( "parent", Maybe.Extra.unwrap Json.Encode.null Prng.Uuid.encode a.parent )
        , ( "eventTypes", Json.Encode.list Prng.Uuid.encode a.eventTypes )
        ]


processTypeDecoder : Json.Decode.Decoder ProcessType
processTypeDecoder =
    Json.Decode.succeed ProcessType
        |> Json.Decode.Pipeline.required "what" Ontology.Hierarchy.Type.typeDecoder
        |> Json.Decode.Pipeline.required "uuid" Prng.Uuid.decoder
        |> Json.Decode.Pipeline.required "parent" (Json.Decode.nullable Prng.Uuid.decoder)
        |> Json.Decode.Pipeline.required "eventTypes" (Json.Decode.list Prng.Uuid.decoder)
