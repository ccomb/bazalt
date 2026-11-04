module Ontology.Calendar exposing
    ( Month(..)
    , Weekday(..)
    , monthDecoder
    , monthEncoder
    , weekdayDecoder
    , weekdayEncoder
    )

import Json.Decode
import Json.Encode


type Month
    = Jan
    | Feb
    | Mar
    | Apr
    | May
    | Jun
    | Jul
    | Aug
    | Sep
    | Oct
    | Nov
    | Dec


monthEncoder : Month -> Json.Encode.Value
monthEncoder a =
    case a of
        Jan ->
            Json.Encode.string "Jan"

        Feb ->
            Json.Encode.string "Feb"

        Mar ->
            Json.Encode.string "Mar"

        Apr ->
            Json.Encode.string "Apr"

        May ->
            Json.Encode.string "May"

        Jun ->
            Json.Encode.string "Jun"

        Jul ->
            Json.Encode.string "Jul"

        Aug ->
            Json.Encode.string "Aug"

        Sep ->
            Json.Encode.string "Sep"

        Oct ->
            Json.Encode.string "Oct"

        Nov ->
            Json.Encode.string "Nov"

        Dec ->
            Json.Encode.string "Dec"


monthDecoder : Json.Decode.Decoder Month
monthDecoder =
    Json.Decode.string
        |> Json.Decode.andThen
            (\a ->
                case a of
                    "Jan" ->
                        Json.Decode.succeed Jan

                    "Feb" ->
                        Json.Decode.succeed Feb

                    "Mar" ->
                        Json.Decode.succeed Mar

                    "Apr" ->
                        Json.Decode.succeed Apr

                    "May" ->
                        Json.Decode.succeed May

                    "Jun" ->
                        Json.Decode.succeed Jun

                    "Jul" ->
                        Json.Decode.succeed Jul

                    "Aug" ->
                        Json.Decode.succeed Aug

                    "Sep" ->
                        Json.Decode.succeed Sep

                    "Oct" ->
                        Json.Decode.succeed Oct

                    "Nov" ->
                        Json.Decode.succeed Nov

                    "Dec" ->
                        Json.Decode.succeed Dec

                    _ ->
                        Json.Decode.fail "No matching constructor"
            )


type Weekday
    = Mon
    | Tue
    | Wed
    | Thu
    | Fri
    | Sat
    | Sun


weekdayEncoder : Weekday -> Json.Encode.Value
weekdayEncoder a =
    case a of
        Mon ->
            Json.Encode.string "Mon"

        Tue ->
            Json.Encode.string "Tue"

        Wed ->
            Json.Encode.string "Wed"

        Thu ->
            Json.Encode.string "Thu"

        Fri ->
            Json.Encode.string "Fri"

        Sat ->
            Json.Encode.string "Sat"

        Sun ->
            Json.Encode.string "Sun"


weekdayDecoder : Json.Decode.Decoder Weekday
weekdayDecoder =
    Json.Decode.string
        |> Json.Decode.andThen
            (\a ->
                case a of
                    "Mon" ->
                        Json.Decode.succeed Mon

                    "Tue" ->
                        Json.Decode.succeed Tue

                    "Wed" ->
                        Json.Decode.succeed Wed

                    "Thu" ->
                        Json.Decode.succeed Thu

                    "Fri" ->
                        Json.Decode.succeed Fri

                    "Sat" ->
                        Json.Decode.succeed Sat

                    "Sun" ->
                        Json.Decode.succeed Sun

                    _ ->
                        Json.Decode.fail "No matching constructor"
            )
