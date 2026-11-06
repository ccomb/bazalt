module Ontology.Resource.Resource exposing
    ( Resource
    , resourceDecoder
    , resourceEncoder
    )

import Json.Decode
import Json.Decode.Pipeline
import Json.Encode
import Ontology.Prim
import Ontology.Typed.Type
import Prng.Uuid


type alias Resource =
    { what : Ontology.Typed.Type.Type
    , uuid : Prng.Uuid.Uuid
    , type_ : Prng.Uuid.Uuid
    , qty : Ontology.Prim.Rational
    }


resourceEncoder : Resource -> Json.Encode.Value
resourceEncoder a =
    Json.Encode.object
        [ ( "what", Ontology.Typed.Type.typeEncoder a.what )
        , ( "uuid", Prng.Uuid.encode a.uuid )
        , ( "type_", Prng.Uuid.encode a.type_ )
        , ( "qty", Ontology.Prim.rationalEncoder a.qty )
        ]


resourceDecoder : Json.Decode.Decoder Resource
resourceDecoder =
    Json.Decode.succeed Resource
        |> Json.Decode.Pipeline.required "what" Ontology.Typed.Type.typeDecoder
        |> Json.Decode.Pipeline.required "uuid" Prng.Uuid.decoder
        |> Json.Decode.Pipeline.required "type_" Prng.Uuid.decoder
        |> Json.Decode.Pipeline.required "qty" Ontology.Prim.rationalDecoder
