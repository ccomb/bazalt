module DateTime exposing (fromCalendarMonth, fromCalendarWeekday, monthToLongString, monthToString, toStrMM, toString, weekdayToLongString, weekdayToString)

import Ontology.Calendar as Calendar
import Time exposing (Month(..), Posix, Weekday(..), Zone)


toString : Zone -> Posix -> String
toString zone posix =
    (weekdayToLongString <| Time.toWeekday zone posix)
        ++ ", "
        ++ (String.fromInt <| Time.toDay zone posix)
        ++ " "
        ++ (monthToLongString <| Time.toMonth zone posix)
        ++ " "
        ++ (String.fromInt <| Time.toYear zone posix)


toStrMM : Month -> String
toStrMM month =
    case month of
        Jan ->
            "01"

        Feb ->
            "02"

        Mar ->
            "03"

        Apr ->
            "04"

        May ->
            "05"

        Jun ->
            "06"

        Jul ->
            "07"

        Aug ->
            "08"

        Sep ->
            "09"

        Oct ->
            "10"

        Nov ->
            "11"

        Dec ->
            "12"


monthToString : Month -> String
monthToString month =
    case month of
        Jan ->
            "Jan"

        Feb ->
            "Feb"

        Mar ->
            "Mar"

        Apr ->
            "Apr"

        May ->
            "May"

        Jun ->
            "Jun"

        Jul ->
            "Jul"

        Aug ->
            "Aug"

        Sep ->
            "Sep"

        Oct ->
            "Oct"

        Nov ->
            "Nov"

        Dec ->
            "Dec"


monthToLongString : Month -> String
monthToLongString month =
    case month of
        Jan ->
            "January"

        Feb ->
            "February"

        Mar ->
            "March"

        Apr ->
            "April"

        May ->
            "May"

        Jun ->
            "June"

        Jul ->
            "July"

        Aug ->
            "August"

        Sep ->
            "September"

        Oct ->
            "October"

        Nov ->
            "November"

        Dec ->
            "December"


weekdayToLongString : Weekday -> String
weekdayToLongString weekday =
    case weekday of
        Mon ->
            "Monday"

        Tue ->
            "Tuesday"

        Wed ->
            "Wednesday"

        Thu ->
            "Thursday"

        Fri ->
            "Friday"

        Sat ->
            "Saturday"

        Sun ->
            "Sunday"


weekdayToString : Weekday -> String
weekdayToString weekday =
    case weekday of
        Mon ->
            "Mon"

        Tue ->
            "Tue"

        Wed ->
            "Wed"

        Thu ->
            "Thu"

        Fri ->
            "Fri"

        Sat ->
            "Sat"

        Sun ->
            "Sun"


fromCalendarMonth : Calendar.Month -> Time.Month
fromCalendarMonth x =
    case x of
        Calendar.Jan ->
            Time.Jan

        Calendar.Feb ->
            Time.Feb

        Calendar.Mar ->
            Time.Mar

        Calendar.Apr ->
            Time.Apr

        Calendar.May ->
            Time.May

        Calendar.Jun ->
            Time.Jun

        Calendar.Jul ->
            Time.Jul

        Calendar.Aug ->
            Time.Aug

        Calendar.Sep ->
            Time.Sep

        Calendar.Oct ->
            Time.Oct

        Calendar.Nov ->
            Time.Nov

        Calendar.Dec ->
            Time.Dec


fromCalendarWeekday : Calendar.Weekday -> Time.Weekday
fromCalendarWeekday x =
    case x of
        Calendar.Mon ->
            Time.Mon

        Calendar.Tue ->
            Time.Tue

        Calendar.Wed ->
            Time.Wed

        Calendar.Thu ->
            Time.Thu

        Calendar.Fri ->
            Time.Fri

        Calendar.Sat ->
            Time.Sat

        Calendar.Sun ->
            Time.Sun
