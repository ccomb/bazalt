module Ontology.Value.ValueType exposing
    ( ValueType
    , valueTypeDecoder
    , valueTypeEncoder
    )

import Json.Decode
import Json.Decode.Pipeline
import Json.Encode
import Ontology.Expression
import Ontology.Scope


type alias ValueType =
    { name : String
    , expr : Ontology.Expression.Expression
    , scope : Ontology.Scope.Scope
    , mandatory : Bool
    }


valueTypeEncoder : ValueType -> Json.Encode.Value
valueTypeEncoder a =
    Json.Encode.object
        [ ( "name", Json.Encode.string a.name )
        , ( "expr", Ontology.Expression.expressionEncoder a.expr )
        , ( "scope", Ontology.Scope.scopeEncoder a.scope )
        , ( "mandatory", Json.Encode.bool a.mandatory )
        ]


valueTypeDecoder : Json.Decode.Decoder ValueType
valueTypeDecoder =
    Json.Decode.succeed ValueType
        |> Json.Decode.Pipeline.required "name" Json.Decode.string
        |> Json.Decode.Pipeline.required "expr" Ontology.Expression.expressionDecoder
        |> Json.Decode.Pipeline.required "scope" Ontology.Scope.scopeDecoder
        |> Json.Decode.Pipeline.required "mandatory" Json.Decode.bool
