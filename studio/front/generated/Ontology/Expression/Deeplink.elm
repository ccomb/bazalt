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
    | Link
        { hardlink : Ontology.Expression.HardLink.HardLink
        , deeplink : DeepLink
        }
    | EndPoint { scope : Ontology.Scope.Scope, name : String }


deepLinkEncoder : DeepLink -> Json.Encode.Value
deepLinkEncoder a =
    case a of
        Null ->
            Json.Encode.object [ ( "type", Json.Encode.string "Null" ) ]

        Link b ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "Link" )
                , ( "hardlink", Ontology.Expression.HardLink.hardLinkEncoder b.hardlink )
                , ( "deeplink", deepLinkEncoder b.deeplink )
                ]

        EndPoint b ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "EndPoint" )
                , ( "scope", Ontology.Scope.scopeEncoder b.scope )
                , ( "name", Json.Encode.string b.name )
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
                        Json.Decode.map Link
                            (Json.Decode.succeed
                                (\b c ->
                                    { hardlink = b
                                    , deeplink = c
                                    }
                                )
                                |> Json.Decode.Pipeline.required "hardlink" Ontology.Expression.HardLink.hardLinkDecoder
                                |> Json.Decode.Pipeline.required "deeplink" deepLinkDecoder
                            )

                    "EndPoint" ->
                        Json.Decode.map EndPoint
                            (Json.Decode.succeed
                                (\b c ->
                                    { scope = b
                                    , name = c
                                    }
                                )
                                |> Json.Decode.Pipeline.required "scope" Ontology.Scope.scopeDecoder
                                |> Json.Decode.Pipeline.required "name" Json.Decode.string
                            )

                    _ ->
                        Json.Decode.fail "No matching constructor"
            )
