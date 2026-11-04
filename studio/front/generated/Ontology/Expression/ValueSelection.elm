module Ontology.Expression.ValueSelection exposing
    ( ValueSelection(..)
    , valueSelectionDecoder
    , valueSelectionEncoder
    )

import Json.Decode
import Json.Decode.Pipeline
import Json.Encode
import Ontology.Type
import Prng.Uuid


type ValueSelection
    = SelectedValue
        { what : Ontology.Type.Type
        , for : Prng.Uuid.Uuid
        , name : String
        }
    | UndefinedValue


valueSelectionEncoder : ValueSelection -> Json.Encode.Value
valueSelectionEncoder a =
    case a of
        SelectedValue b ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "SelectedValue" )
                , ( "what", Ontology.Type.typeEncoder b.what )
                , ( "for", Prng.Uuid.encode b.for )
                , ( "name", Json.Encode.string b.name )
                ]

        UndefinedValue ->
            Json.Encode.object [ ( "type", Json.Encode.string "UndefinedValue" ) ]


valueSelectionDecoder : Json.Decode.Decoder ValueSelection
valueSelectionDecoder =
    Json.Decode.field "type" Json.Decode.string
        |> Json.Decode.andThen
            (\a ->
                case a of
                    "SelectedValue" ->
                        Json.Decode.map SelectedValue
                            (Json.Decode.succeed
                                (\b c d ->
                                    { what = b
                                    , for = c
                                    , name = d
                                    }
                                )
                                |> Json.Decode.Pipeline.required "what" Ontology.Type.typeDecoder
                                |> Json.Decode.Pipeline.required "for" Prng.Uuid.decoder
                                |> Json.Decode.Pipeline.required "name" Json.Decode.string
                            )

                    "UndefinedValue" ->
                        Json.Decode.succeed UndefinedValue

                    _ ->
                        Json.Decode.fail "No matching constructor"
            )
