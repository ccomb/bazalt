module Ontology.MessageFlow exposing
    ( MessageFlow(..)
    , messageFlowDecoder
    , messageFlowEncoder
    )

import Json.Decode
import Json.Decode.Pipeline
import Json.Encode


type MessageFlow
    = Requested
    | Processed
    | Error String


messageFlowEncoder : MessageFlow -> Json.Encode.Value
messageFlowEncoder a =
    case a of
        Requested ->
            Json.Encode.object [ ( "type", Json.Encode.string "Requested" ) ]

        Processed ->
            Json.Encode.object [ ( "type", Json.Encode.string "Processed" ) ]

        Error b ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "Error" )
                , ( "value", Json.Encode.string b )
                ]


messageFlowDecoder : Json.Decode.Decoder MessageFlow
messageFlowDecoder =
    Json.Decode.field "type" Json.Decode.string
        |> Json.Decode.andThen
            (\a ->
                case a of
                    "Requested" ->
                        Json.Decode.succeed Requested

                    "Processed" ->
                        Json.Decode.succeed Processed

                    "Error" ->
                        Json.Decode.succeed Error
                            |> Json.Decode.Pipeline.required "value" Json.Decode.string

                    _ ->
                        Json.Decode.fail "No matching constructor"
            )
