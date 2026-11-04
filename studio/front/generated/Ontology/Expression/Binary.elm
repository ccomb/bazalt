module Ontology.Expression.Binary exposing
    ( Operator(..)
    , operatorDecoder
    , operatorEncoder
    )

import Json.Decode
import Json.Decode.Pipeline
import Json.Encode
import Maybe.Extra


type Operator
    = Add
    | Multiply
    | Or { name : String, desc : String, choice : Maybe Bool }
    | Otherwise


operatorEncoder : Operator -> Json.Encode.Value
operatorEncoder a =
    case a of
        Add ->
            Json.Encode.object [ ( "type", Json.Encode.string "Add" ) ]

        Multiply ->
            Json.Encode.object [ ( "type", Json.Encode.string "Multiply" ) ]

        Or b ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "Or" )
                , ( "name", Json.Encode.string b.name )
                , ( "desc", Json.Encode.string b.desc )
                , ( "choice", Maybe.Extra.unwrap Json.Encode.null Json.Encode.bool b.choice )
                ]

        Otherwise ->
            Json.Encode.object [ ( "type", Json.Encode.string "Otherwise" ) ]


operatorDecoder : Json.Decode.Decoder Operator
operatorDecoder =
    Json.Decode.field "type" Json.Decode.string
        |> Json.Decode.andThen
            (\a ->
                case a of
                    "Add" ->
                        Json.Decode.succeed Add

                    "Multiply" ->
                        Json.Decode.succeed Multiply

                    "Or" ->
                        Json.Decode.map Or
                            (Json.Decode.succeed
                                (\b c d ->
                                    { name = b
                                    , desc = c
                                    , choice = d
                                    }
                                )
                                |> Json.Decode.Pipeline.required "name" Json.Decode.string
                                |> Json.Decode.Pipeline.required "desc" Json.Decode.string
                                |> Json.Decode.Pipeline.required "choice" (Json.Decode.nullable Json.Decode.bool)
                            )

                    "Otherwise" ->
                        Json.Decode.succeed Otherwise

                    _ ->
                        Json.Decode.fail "No matching constructor"
            )
