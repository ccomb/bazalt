module Ontology.Group.Link exposing
    ( Link
    , linkDecoder
    , linkEncoder
    )

import Json.Decode
import Json.Decode.Pipeline
import Json.Encode
import Ontology.Type
import Prng.Uuid


type alias Link =
    { what : Ontology.Type.Type
    , groupable : Prng.Uuid.Uuid
    , group : Prng.Uuid.Uuid
    }


linkEncoder : Link -> Json.Encode.Value
linkEncoder a =
    Json.Encode.object
        [ ( "what", Ontology.Type.typeEncoder a.what )
        , ( "groupable", Prng.Uuid.encode a.groupable )
        , ( "group", Prng.Uuid.encode a.group )
        ]


linkDecoder : Json.Decode.Decoder Link
linkDecoder =
    Json.Decode.succeed Link
        |> Json.Decode.Pipeline.required "what" Ontology.Type.typeDecoder
        |> Json.Decode.Pipeline.required "groupable" Prng.Uuid.decoder
        |> Json.Decode.Pipeline.required "group" Prng.Uuid.decoder
