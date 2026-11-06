module Ontology.Expression.Deeplink exposing
    ( DeepLink(..)
    , deepLinkDecoder
    , deepLinkEncoder
    )

import Json.Decode
import Json.Decode.Pipeline
import Json.Encode
import Ontology.Expression.HardLink
import Ontology.Scope


type DeepLink
    = Null
    | Link Ontology.Expression.HardLink.HardLink DeepLink
    | EndPoint Ontology.Scope.Scope String


deepLinkEncoder : DeepLink -> Json.Encode.Value
deepLinkEncoder a =
    case a of
        Null ->
            Json.Encode.object [ ( "type", Json.Encode.string "Null" ) ]

        Link b c ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "Link" )
                , ( "value"
                  , Json.Encode.list identity
                        [ Ontology.Expression.HardLink.hardLinkEncoder b
                        , deepLinkEncoder c
                        ]
                  )
                ]

        EndPoint b c ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "EndPoint" )
                , ( "value"
                  , Json.Encode.list identity
                        [ Ontology.Scope.scopeEncoder b
                        , Json.Encode.string c
                        ]
                  )
                ]


deepLinkDecoder : Json.Decode.Decoder DeepLink
deepLinkDecoder =
    Json.Decode.field "type" Json.Decode.string
        |> Json.Decode.andThen
            (\a ->
                case a of
                    "Null" ->
                        Json.Decode.succeed Null

                    "Link" ->
                        Json.Decode.field "value"
                            (Json.Decode.succeed Link
                                |> Json.Decode.Pipeline.custom (Json.Decode.index 0 Ontology.Expression.HardLink.hardLinkDecoder)
                                |> Json.Decode.Pipeline.custom (Json.Decode.index 1 deepLinkDecoder)
                            )

                    "EndPoint" ->
                        Json.Decode.field "value"
                            (Json.Decode.succeed EndPoint
                                |> Json.Decode.Pipeline.custom (Json.Decode.index 0 Ontology.Scope.scopeDecoder)
                                |> Json.Decode.Pipeline.custom (Json.Decode.index 1 Json.Decode.string)
                            )

                    _ ->
                        Json.Decode.fail "No matching constructor"
            )
