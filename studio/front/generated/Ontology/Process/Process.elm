module Ontology.Process.Process exposing
    ( Process
    , processDecoder
    , processEncoder
    )

import Json.Decode
import Json.Decode.Pipeline
import Json.Encode
import Ontology.Type
import Prng.Uuid


type alias Process =
    { what : Ontology.Type.Type, uuid : Prng.Uuid.Uuid, type_ : Prng.Uuid.Uuid }


processEncoder : Process -> Json.Encode.Value
processEncoder a =
    Json.Encode.object
        [ ( "what", Ontology.Type.typeEncoder a.what )
        , ( "uuid", Prng.Uuid.encode a.uuid )
        , ( "type_", Prng.Uuid.encode a.type_ )
        ]


processDecoder : Json.Decode.Decoder Process
processDecoder =
    Json.Decode.succeed Process
        |> Json.Decode.Pipeline.required "what" Ontology.Type.typeDecoder
        |> Json.Decode.Pipeline.required "uuid" Prng.Uuid.decoder
        |> Json.Decode.Pipeline.required "type_" Prng.Uuid.decoder
