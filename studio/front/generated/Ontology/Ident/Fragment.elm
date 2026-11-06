module Ontology.Ident.Fragment exposing
    ( Fragment(..)
    , fragmentDecoder
    , fragmentEncoder
    )

import Json.Decode
import Json.Decode.Pipeline
import Json.Encode
import Maybe.Extra
import Ontology.Calendar
import Ontology.Prim
import Time


type Fragment
    = Free String
    | Fixed String
    | Sequence
        { name : String
        , padding : Int
        , step : Int
        , start : Int
        , val : Maybe Int
        }
    | Existing { name : String, value : String }
    | YYYY Int
    | YY Int
    | MMMM Ontology.Calendar.Month
    | MM Ontology.Calendar.Month
    | Weekday Ontology.Calendar.Weekday
    | DoM Int
    | Hour Int
    | Minute Int
    | Second Int
    | DateFrom { field : String, when : Time.Posix }


fragmentEncoder : Fragment -> Json.Encode.Value
fragmentEncoder a =
    case a of
        Free b ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "Free" )
                , ( "value", Json.Encode.string b )
                ]

        Fixed b ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "Fixed" )
                , ( "value", Json.Encode.string b )
                ]

        Sequence b ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "Sequence" )
                , ( "name", Json.Encode.string b.name )
                , ( "padding", Json.Encode.int b.padding )
                , ( "step", Json.Encode.int b.step )
                , ( "start", Json.Encode.int b.start )
                , ( "val", Maybe.Extra.unwrap Json.Encode.null Json.Encode.int b.val )
                ]

        Existing b ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "Existing" )
                , ( "name", Json.Encode.string b.name )
                , ( "value", Json.Encode.string b.value )
                ]

        YYYY b ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "YYYY" )
                , ( "value", Json.Encode.int b )
                ]

        YY b ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "YY" )
                , ( "value", Json.Encode.int b )
                ]

        MMMM b ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "MMMM" )
                , ( "value", Ontology.Calendar.monthEncoder b )
                ]

        MM b ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "MM" )
                , ( "value", Ontology.Calendar.monthEncoder b )
                ]

        Weekday b ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "Weekday" )
                , ( "value", Ontology.Calendar.weekdayEncoder b )
                ]

        DoM b ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "DoM" )
                , ( "value", Json.Encode.int b )
                ]

        Hour b ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "Hour" )
                , ( "value", Json.Encode.int b )
                ]

        Minute b ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "Minute" )
                , ( "value", Json.Encode.int b )
                ]

        Second b ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "Second" )
                , ( "value", Json.Encode.int b )
                ]

        DateFrom b ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "DateFrom" )
                , ( "field", Json.Encode.string b.field )
                , ( "when", Ontology.Prim.posixEncoder b.when )
                ]


fragmentDecoder : Json.Decode.Decoder Fragment
fragmentDecoder =
    Json.Decode.field "type" Json.Decode.string
        |> Json.Decode.andThen
            (\a ->
                case a of
                    "Free" ->
                        Json.Decode.succeed Free
                            |> Json.Decode.Pipeline.required "value" Json.Decode.string

                    "Fixed" ->
                        Json.Decode.succeed Fixed
                            |> Json.Decode.Pipeline.required "value" Json.Decode.string

                    "Sequence" ->
                        Json.Decode.map Sequence
                            (Json.Decode.succeed
                                (\b c d e f ->
                                    { name = b
                                    , padding = c
                                    , step = d
                                    , start = e
                                    , val = f
                                    }
                                )
                                |> Json.Decode.Pipeline.required "name" Json.Decode.string
                                |> Json.Decode.Pipeline.required "padding" Json.Decode.int
                                |> Json.Decode.Pipeline.required "step" Json.Decode.int
                                |> Json.Decode.Pipeline.required "start" Json.Decode.int
                                |> Json.Decode.Pipeline.required "val" (Json.Decode.nullable Json.Decode.int)
                            )

                    "Existing" ->
                        Json.Decode.map Existing
                            (Json.Decode.succeed
                                (\b c ->
                                    { name = b
                                    , value = c
                                    }
                                )
                                |> Json.Decode.Pipeline.required "name" Json.Decode.string
                                |> Json.Decode.Pipeline.required "value" Json.Decode.string
                            )

                    "YYYY" ->
                        Json.Decode.succeed YYYY
                            |> Json.Decode.Pipeline.required "value" Json.Decode.int

                    "YY" ->
                        Json.Decode.succeed YY
                            |> Json.Decode.Pipeline.required "value" Json.Decode.int

                    "MMMM" ->
                        Json.Decode.succeed MMMM
                            |> Json.Decode.Pipeline.required "value" Ontology.Calendar.monthDecoder

                    "MM" ->
                        Json.Decode.succeed MM
                            |> Json.Decode.Pipeline.required "value" Ontology.Calendar.monthDecoder

                    "Weekday" ->
                        Json.Decode.succeed Weekday
                            |> Json.Decode.Pipeline.required "value" Ontology.Calendar.weekdayDecoder

                    "DoM" ->
                        Json.Decode.succeed DoM
                            |> Json.Decode.Pipeline.required "value" Json.Decode.int

                    "Hour" ->
                        Json.Decode.succeed Hour
                            |> Json.Decode.Pipeline.required "value" Json.Decode.int

                    "Minute" ->
                        Json.Decode.succeed Minute
                            |> Json.Decode.Pipeline.required "value" Json.Decode.int

                    "Second" ->
                        Json.Decode.succeed Second
                            |> Json.Decode.Pipeline.required "value" Json.Decode.int

                    "DateFrom" ->
                        Json.Decode.map DateFrom
                            (Json.Decode.succeed
                                (\b c ->
                                    { field = b
                                    , when = c
                                    }
                                )
                                |> Json.Decode.Pipeline.required "field" Json.Decode.string
                                |> Json.Decode.Pipeline.required "when" Ontology.Prim.posixDecoder
                            )

                    _ ->
                        Json.Decode.fail "No matching constructor"
            )
