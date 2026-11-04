module Ident.Fragment exposing (all, toDesc, toString, toValue)

import DateTime exposing (fromCalendarMonth, fromCalendarWeekday, monthToString, toStrMM, weekdayToString)
import Ontology.Calendar as Calendar
import Ontology.Ident.Fragment exposing (Fragment(..))
import String exposing (padLeft)
import Time exposing (millisToPosix, posixToMillis)


all : List Fragment
all =
    [ Free ""
    , Fixed ""
    , Sequence { name = "", padding = 4, step = 1, start = 0, val = Nothing }
    , Existing { name = "", value = "" }
    , YYYY 0
    , YY 0
    , MMMM Calendar.Jan
    , MM Calendar.Jan
    , Weekday Calendar.Mon
    , DoM 0
    , Hour 0
    , Minute 0
    , Second 0
    , DateFrom { field = "", when = millisToPosix 0 }
    ]


toString : Fragment -> String
toString f =
    case f of
        Free _ ->
            "Free"

        Fixed _ ->
            "Fixed"

        Sequence _ ->
            "Sequence"

        Existing _ ->
            "Existing"

        YYYY _ ->
            "YYYY"

        YY _ ->
            "YY"

        MMMM _ ->
            "MMMM"

        MM _ ->
            "MM"

        Weekday _ ->
            "Weekday"

        DoM _ ->
            "DoM"

        Hour _ ->
            "hh"

        Minute _ ->
            "mm"

        Second _ ->
            "ss"

        DateFrom _ ->
            "Date from another field"


toValue : Fragment -> String
toValue f =
    case f of
        Free value ->
            value

        Fixed value ->
            value

        Sequence s ->
            padLeft s.padding '0' <| Maybe.withDefault "?" <| Maybe.map String.fromInt s.val

        Existing e ->
            e.value

        YYYY value ->
            String.fromInt value

        YY value ->
            String.fromInt value

        MMMM value ->
            monthToString (fromCalendarMonth value)

        MM value ->
            toStrMM (fromCalendarMonth value)

        Weekday value ->
            weekdayToString (fromCalendarWeekday value)

        DoM value ->
            String.fromInt value

        Hour value ->
            String.fromInt value

        Minute value ->
            String.fromInt value

        Second value ->
            String.fromInt value

        DateFrom d ->
            String.fromInt <| posixToMillis d.when


toDesc : Fragment -> String
toDesc f =
    case f of
        Free _ ->
            "A free text that you will be able to enter to identify a new entity."

        Fixed _ ->
            "A fixed text that you define now and that will be always the same. For instance it can be a prefix, a suffix, a separator."

        Sequence _ ->
            "A sequence number used to identify an entity. You can configure the name of the sequence, the number of figures, the increment and the starting number"

        Existing _ ->
            "An existing identifierType for an entity."

        YYYY _ ->
            "The year on 4 digits"

        YY _ ->
            "The year on 2 digits"

        MMMM _ ->
            "The month in long form. Ex: August"

        MM _ ->
            "The month on 2 digits."

        Weekday _ ->
            "Day of week in long form (Ex: Saturday)"

        DoM _ ->
            "Day of month on 2 digits"

        Hour _ ->
            "Hour on 2 digits"

        Minute _ ->
            "Minute on 2 digits"

        Second _ ->
            "Second on 2 digits"

        DateFrom d ->
            "Date coming from another field: " ++ d.field
