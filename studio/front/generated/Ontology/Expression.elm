module Ontology.Expression exposing
    ( Expression(..)
    , expressionDecoder
    , expressionEncoder
    )

import Json.Decode
import Json.Decode.Pipeline
import Json.Encode
import Ontology.Expression.Binary
import Ontology.Expression.Observable
import Ontology.Expression.Unary


type Expression
    = Leaf Ontology.Expression.Observable.Observable
    | Unary { uop : Ontology.Expression.Unary.Operator, expr : Expression }
    | Binary
        { bop : Ontology.Expression.Binary.Operator
        , expr1 : Expression
        , expr2 : Expression
        }


expressionEncoder : Expression -> Json.Encode.Value
expressionEncoder a =
    case a of
        Leaf b ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "Leaf" )
                , ( "value", Ontology.Expression.Observable.observableEncoder b )
                ]

        Unary b ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "Unary" )
                , ( "uop", Ontology.Expression.Unary.operatorEncoder b.uop )
                , ( "expr", expressionEncoder b.expr )
                ]

        Binary b ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "Binary" )
                , ( "bop", Ontology.Expression.Binary.operatorEncoder b.bop )
                , ( "expr1", expressionEncoder b.expr1 )
                , ( "expr2", expressionEncoder b.expr2 )
                ]


expressionDecoder : Json.Decode.Decoder Expression
expressionDecoder =
    Json.Decode.field "type" Json.Decode.string
        |> Json.Decode.andThen
            (\a ->
                case a of
                    "Leaf" ->
                        Json.Decode.succeed Leaf
                            |> Json.Decode.Pipeline.required "value" Ontology.Expression.Observable.observableDecoder

                    "Unary" ->
                        Json.Decode.map Unary
                            (Json.Decode.succeed
                                (\b c ->
                                    { uop = b
                                    , expr = c
                                    }
                                )
                                |> Json.Decode.Pipeline.required "uop" Ontology.Expression.Unary.operatorDecoder
                                |> Json.Decode.Pipeline.required "expr" expressionDecoder
                            )

                    "Binary" ->
                        Json.Decode.map Binary
                            (Json.Decode.succeed
                                (\b c d ->
                                    { bop = b
                                    , expr1 = c
                                    , expr2 = d
                                    }
                                )
                                |> Json.Decode.Pipeline.required "bop" Ontology.Expression.Binary.operatorDecoder
                                |> Json.Decode.Pipeline.required "expr1" expressionDecoder
                                |> Json.Decode.Pipeline.required "expr2" expressionDecoder
                            )

                    _ ->
                        Json.Decode.fail "No matching constructor"
            )
