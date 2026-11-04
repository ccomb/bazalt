module Ontology.Type exposing
    ( Type(..)
    , typeDecoder
    , typeEncoder
    )

import Json.Decode
import Json.Decode.Pipeline
import Json.Encode
import Ontology.Hierarchy.Type
import Ontology.Typed.Type


type Type
    = TType Ontology.Typed.Type.Type
    | HType Ontology.Hierarchy.Type.Type


typeEncoder : Type -> Json.Encode.Value
typeEncoder a =
    case a of
        TType b ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "TType" )
                , ( "value", Ontology.Typed.Type.typeEncoder b )
                ]

        HType b ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "HType" )
                , ( "value", Ontology.Hierarchy.Type.typeEncoder b )
                ]


typeDecoder : Json.Decode.Decoder Type
typeDecoder =
    Json.Decode.field "type" Json.Decode.string
        |> Json.Decode.andThen
            (\a ->
                case a of
                    "TType" ->
                        Json.Decode.succeed TType
                            |> Json.Decode.Pipeline.required "value" Ontology.Typed.Type.typeDecoder

                    "HType" ->
                        Json.Decode.succeed HType
                            |> Json.Decode.Pipeline.required "value" Ontology.Hierarchy.Type.typeDecoder

                    _ ->
                        Json.Decode.fail "No matching constructor"
            )
