module Ontology.Ident.Identification exposing
    ( Identification(..)
    , identificationDecoder
    , identificationEncoder
    )

import Json.Decode
import Json.Decode.Pipeline
import Json.Encode


type Identification
    = StartsWith String
    | EndsWith String
    | Contains String


identificationEncoder : Identification -> Json.Encode.Value
identificationEncoder a =
    case a of
        StartsWith b ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "StartsWith" )
                , ( "value", Json.Encode.string b )
                ]

        EndsWith b ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "EndsWith" )
                , ( "value", Json.Encode.string b )
                ]

        Contains b ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "Contains" )
                , ( "value", Json.Encode.string b )
                ]


identificationDecoder : Json.Decode.Decoder Identification
identificationDecoder =
    Json.Decode.field "type" Json.Decode.string
        |> Json.Decode.andThen
            (\a ->
                case a of
                    "StartsWith" ->
                        Json.Decode.succeed StartsWith
                            |> Json.Decode.Pipeline.required "value" Json.Decode.string

                    "EndsWith" ->
                        Json.Decode.succeed EndsWith
                            |> Json.Decode.Pipeline.required "value" Json.Decode.string

                    "Contains" ->
                        Json.Decode.succeed Contains
                            |> Json.Decode.Pipeline.required "value" Json.Decode.string

                    _ ->
                        Json.Decode.fail "No matching constructor"
            )
