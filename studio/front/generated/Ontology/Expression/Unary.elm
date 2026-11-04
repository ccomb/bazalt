module Ontology.Expression.Unary exposing
    ( Operator(..)
    , operatorDecoder
    , operatorEncoder
    )

import Json.Decode
import Json.Encode


type Operator
    = Neg
    | Inv


operatorEncoder : Operator -> Json.Encode.Value
operatorEncoder a =
    case a of
        Neg ->
            Json.Encode.string "Neg"

        Inv ->
            Json.Encode.string "Inv"


operatorDecoder : Json.Decode.Decoder Operator
operatorDecoder =
    Json.Decode.string
        |> Json.Decode.andThen
            (\a ->
                case a of
                    "Neg" ->
                        Json.Decode.succeed Neg

                    "Inv" ->
                        Json.Decode.succeed Inv

                    _ ->
                        Json.Decode.fail "No matching constructor"
            )
