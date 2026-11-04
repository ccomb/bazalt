module Ontology.Value.Value exposing
    ( Value
    , valueDecoder
    , valueEncoder
    )

import Json.Decode
import Json.Decode.Pipeline
import Json.Encode
import Ontology.Expression
import Ontology.Type
import Prng.Uuid


type alias Value =
    { what : Ontology.Type.Type
    , for : Prng.Uuid.Uuid
    , name : String
    , expr : Ontology.Expression.Expression
    }


valueEncoder : Value -> Json.Encode.Value
valueEncoder a =
    Json.Encode.object
        [ ( "what", Ontology.Type.typeEncoder a.what )
        , ( "for", Prng.Uuid.encode a.for )
        , ( "name", Json.Encode.string a.name )
        , ( "expr", Ontology.Expression.expressionEncoder a.expr )
        ]


valueDecoder : Json.Decode.Decoder Value
valueDecoder =
    Json.Decode.succeed Value
        |> Json.Decode.Pipeline.required "what" Ontology.Type.typeDecoder
        |> Json.Decode.Pipeline.required "for" Prng.Uuid.decoder
        |> Json.Decode.Pipeline.required "name" Json.Decode.string
        |> Json.Decode.Pipeline.required "expr" Ontology.Expression.expressionDecoder
