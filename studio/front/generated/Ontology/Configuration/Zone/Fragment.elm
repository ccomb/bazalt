module Ontology.Configuration.Zone.Fragment exposing
    ( Fragment(..)
    , fragmentDecoder
    , fragmentEncoder
    )

import Json.Decode
import Json.Decode.Pipeline
import Json.Encode
import Ontology.Scope


type Fragment
    = IdentifierName { name : String }
    | GroupIdentifierName { scope : Ontology.Scope.Scope, name : String }
    | Parent
    | Fixed { string : String }
    | Quantity
    | Flow
    | Provider
    | Receiver
    | EventList { qtySep : String, eventSep : String }


fragmentEncoder : Fragment -> Json.Encode.Value
fragmentEncoder a =
    case a of
        IdentifierName b ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "IdentifierName" )
                , ( "name", Json.Encode.string b.name )
                ]

        GroupIdentifierName b ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "GroupIdentifierName" )
                , ( "scope", Ontology.Scope.scopeEncoder b.scope )
                , ( "name", Json.Encode.string b.name )
                ]

        Parent ->
            Json.Encode.object [ ( "type", Json.Encode.string "Parent" ) ]

        Fixed b ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "Fixed" )
                , ( "string", Json.Encode.string b.string )
                ]

        Quantity ->
            Json.Encode.object [ ( "type", Json.Encode.string "Quantity" ) ]

        Flow ->
            Json.Encode.object [ ( "type", Json.Encode.string "Flow" ) ]

        Provider ->
            Json.Encode.object [ ( "type", Json.Encode.string "Provider" ) ]

        Receiver ->
            Json.Encode.object [ ( "type", Json.Encode.string "Receiver" ) ]

        EventList b ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "EventList" )
                , ( "qtySep", Json.Encode.string b.qtySep )
                , ( "eventSep", Json.Encode.string b.eventSep )
                ]


fragmentDecoder : Json.Decode.Decoder Fragment
fragmentDecoder =
    Json.Decode.field "type" Json.Decode.string
        |> Json.Decode.andThen
            (\a ->
                case a of
                    "IdentifierName" ->
                        Json.Decode.map IdentifierName
                            (Json.Decode.succeed (\b -> { name = b })
                                |> Json.Decode.Pipeline.required "name" Json.Decode.string
                            )

                    "GroupIdentifierName" ->
                        Json.Decode.map GroupIdentifierName
                            (Json.Decode.succeed
                                (\b c ->
                                    { scope = b
                                    , name = c
                                    }
                                )
                                |> Json.Decode.Pipeline.required "scope" Ontology.Scope.scopeDecoder
                                |> Json.Decode.Pipeline.required "name" Json.Decode.string
                            )

                    "Parent" ->
                        Json.Decode.succeed Parent

                    "Fixed" ->
                        Json.Decode.map Fixed
                            (Json.Decode.succeed (\b -> { string = b })
                                |> Json.Decode.Pipeline.required "string" Json.Decode.string
                            )

                    "Quantity" ->
                        Json.Decode.succeed Quantity

                    "Flow" ->
                        Json.Decode.succeed Flow

                    "Provider" ->
                        Json.Decode.succeed Provider

                    "Receiver" ->
                        Json.Decode.succeed Receiver

                    "EventList" ->
                        Json.Decode.map EventList
                            (Json.Decode.succeed
                                (\b c ->
                                    { qtySep = b
                                    , eventSep = c
                                    }
                                )
                                |> Json.Decode.Pipeline.required "qtySep" Json.Decode.string
                                |> Json.Decode.Pipeline.required "eventSep" Json.Decode.string
                            )

                    _ ->
                        Json.Decode.fail "No matching constructor"
            )
