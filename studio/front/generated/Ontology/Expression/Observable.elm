module Ontology.Expression.Observable exposing
    ( Observable(..)
    , observableDecoder
    , observableEncoder
    )

import Json.Decode
import Json.Decode.Pipeline
import Json.Encode
import Ontology.Expression.Deeplink
import Ontology.Expression.ValueSelection


type Observable
    = Constant String
    | Variable { name : String, input : String }
    | ObsValue Ontology.Expression.ValueSelection.ValueSelection
    | ObsLink Ontology.Expression.Deeplink.DeepLink


observableEncoder : Observable -> Json.Encode.Value
observableEncoder a =
    case a of
        Constant b ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "Constant" )
                , ( "value", Json.Encode.string b )
                ]

        Variable b ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "Variable" )
                , ( "name", Json.Encode.string b.name )
                , ( "input", Json.Encode.string b.input )
                ]

        ObsValue b ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "ObsValue" )
                , ( "value", Ontology.Expression.ValueSelection.valueSelectionEncoder b )
                ]

        ObsLink b ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "ObsLink" )
                , ( "value", Ontology.Expression.Deeplink.deepLinkEncoder b )
                ]


observableDecoder : Json.Decode.Decoder Observable
observableDecoder =
    Json.Decode.field "type" Json.Decode.string
        |> Json.Decode.andThen
            (\a ->
                case a of
                    "Constant" ->
                        Json.Decode.succeed Constant
                            |> Json.Decode.Pipeline.required "value" Json.Decode.string

                    "Variable" ->
                        Json.Decode.map Variable
                            (Json.Decode.succeed
                                (\b c ->
                                    { name = b
                                    , input = c
                                    }
                                )
                                |> Json.Decode.Pipeline.required "name" Json.Decode.string
                                |> Json.Decode.Pipeline.required "input" Json.Decode.string
                            )

                    "ObsValue" ->
                        Json.Decode.succeed ObsValue
                            |> Json.Decode.Pipeline.required "value" Ontology.Expression.ValueSelection.valueSelectionDecoder

                    "ObsLink" ->
                        Json.Decode.succeed ObsLink
                            |> Json.Decode.Pipeline.required "value" Ontology.Expression.Deeplink.deepLinkDecoder

                    _ ->
                        Json.Decode.fail "No matching constructor"
            )
