module Ontology.Scope exposing
    ( Scope(..)
    , scopeDecoder
    , scopeEncoder
    )

import Json.Decode
import Json.Decode.Pipeline
import Json.Encode
import Ontology.Ident.Identification
import Ontology.Type
import Prng.Uuid


type Scope
    = Empty
    | Anything
    | IsItem Ontology.Type.Type Prng.Uuid.Uuid
    | HasUserType Ontology.Type.Type Prng.Uuid.Uuid
    | HasType Ontology.Type.Type
    | And Scope Scope
    | Or Scope Scope
    | Not Scope
    | Identified Ontology.Ident.Identification.Identification


scopeEncoder : Scope -> Json.Encode.Value
scopeEncoder a =
    case a of
        Empty ->
            Json.Encode.object [ ( "type", Json.Encode.string "Empty" ) ]

        Anything ->
            Json.Encode.object [ ( "type", Json.Encode.string "Anything" ) ]

        IsItem b c ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "IsItem" )
                , ( "value"
                  , Json.Encode.list identity
                        [ Ontology.Type.typeEncoder b
                        , Prng.Uuid.encode c
                        ]
                  )
                ]

        HasUserType b c ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "HasUserType" )
                , ( "value"
                  , Json.Encode.list identity
                        [ Ontology.Type.typeEncoder b
                        , Prng.Uuid.encode c
                        ]
                  )
                ]

        HasType b ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "HasType" )
                , ( "value", Ontology.Type.typeEncoder b )
                ]

        And b c ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "And" )
                , ( "value"
                  , Json.Encode.list identity
                        [ scopeEncoder b
                        , scopeEncoder c
                        ]
                  )
                ]

        Or b c ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "Or" )
                , ( "value"
                  , Json.Encode.list identity
                        [ scopeEncoder b
                        , scopeEncoder c
                        ]
                  )
                ]

        Not b ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "Not" )
                , ( "value", scopeEncoder b )
                ]

        Identified b ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "Identified" )
                , ( "value", Ontology.Ident.Identification.identificationEncoder b )
                ]


scopeDecoder : Json.Decode.Decoder Scope
scopeDecoder =
    Json.Decode.field "type" Json.Decode.string
        |> Json.Decode.andThen
            (\a ->
                case a of
                    "Empty" ->
                        Json.Decode.succeed Empty

                    "Anything" ->
                        Json.Decode.succeed Anything

                    "IsItem" ->
                        Json.Decode.field "value"
                            (Json.Decode.succeed IsItem
                                |> Json.Decode.Pipeline.custom (Json.Decode.index 0 Ontology.Type.typeDecoder)
                                |> Json.Decode.Pipeline.custom (Json.Decode.index 1 Prng.Uuid.decoder)
                            )

                    "HasUserType" ->
                        Json.Decode.field "value"
                            (Json.Decode.succeed HasUserType
                                |> Json.Decode.Pipeline.custom (Json.Decode.index 0 Ontology.Type.typeDecoder)
                                |> Json.Decode.Pipeline.custom (Json.Decode.index 1 Prng.Uuid.decoder)
                            )

                    "HasType" ->
                        Json.Decode.succeed HasType
                            |> Json.Decode.Pipeline.required "value" Ontology.Type.typeDecoder

                    "And" ->
                        Json.Decode.field "value"
                            (Json.Decode.succeed And
                                |> Json.Decode.Pipeline.custom (Json.Decode.index 0 scopeDecoder)
                                |> Json.Decode.Pipeline.custom (Json.Decode.index 1 scopeDecoder)
                            )

                    "Or" ->
                        Json.Decode.field "value"
                            (Json.Decode.succeed Or
                                |> Json.Decode.Pipeline.custom (Json.Decode.index 0 scopeDecoder)
                                |> Json.Decode.Pipeline.custom (Json.Decode.index 1 scopeDecoder)
                            )

                    "Not" ->
                        Json.Decode.succeed Not
                            |> Json.Decode.Pipeline.required "value" scopeDecoder

                    "Identified" ->
                        Json.Decode.succeed Identified
                            |> Json.Decode.Pipeline.required "value" Ontology.Ident.Identification.identificationDecoder

                    _ ->
                        Json.Decode.fail "No matching constructor"
            )
