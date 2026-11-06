module Expression.Rational exposing (Rational, add, fromString, inv, multiply, neg, one, parse, resultToString, toFloatString, toString, zero)

import Ontology.Prim as Prim


type alias Rational =
    Prim.Rational


rational : Int -> Int -> Rational
rational n d =
    { numerator = n, denominator = d }


zero : Rational
zero =
    rational 0 1


one : Rational
one =
    rational 1 1


neg : Rational -> Rational
neg r =
    { r | numerator = -r.numerator }


inv : Rational -> Rational
inv r =
    rational r.denominator r.numerator


add : Rational -> Rational -> Rational
add r1 r2 =
    rational ((r1.numerator * r2.denominator) + (r2.numerator * r1.denominator)) (r1.denominator * r2.denominator)


multiply : Rational -> Rational -> Rational
multiply r1 r2 =
    rational (r1.numerator * r2.numerator) (r1.denominator * r2.denominator)


fromSlashString : String -> Result String Rational
fromSlashString =
    -- Try to parse a "n/d" string
    -- the error string is the unconverted string
    String.split "/"
        >> (\split ->
                List.head split
                    |> Maybe.andThen String.toInt
                    |> Maybe.map
                        (\left ->
                            List.tail split
                                |> Maybe.map (String.join "/")
                                |> Maybe.andThen String.toInt
                                |> (\maybeRight ->
                                        case maybeRight of
                                            Just right ->
                                                if right == 0 then
                                                    Err "Infinite number"

                                                else
                                                    Ok <| rational left right

                                            Nothing ->
                                                Err "Invalid denominator"
                                   )
                        )
                    |> Maybe.withDefault (Err "Invalid numerator")
           )


fromFloatString : String -> String -> Result String Rational
fromFloatString sep =
    -- Parse a Float String to a Rational (with custom separator)
    String.split sep
        >> (\parts ->
                if List.length parts > 2 then
                    Nothing

                else
                    List.head parts
                        |> Maybe.andThen
                            (\left ->
                                List.tail parts
                                    |> Maybe.andThen
                                        (\tails ->
                                            let
                                                right =
                                                    String.concat tails

                                                lr =
                                                    String.length right
                                            in
                                            Maybe.map2 rational (String.toInt (left ++ right)) (Just (10 ^ lr))
                                        )
                            )
           )
        >> Result.fromMaybe "Invalid floating point number"


fromInt : String -> Result String Rational
fromInt s =
    String.toInt s |> Maybe.map (\n -> rational n 1) |> Result.fromMaybe s


fromPercent : String -> Result String Rational
fromPercent s =
    let
        percent =
            String.right 1 s
    in
    if percent == "%" then
        let
            number =
                String.slice 0 -1 s
        in
        oneOf "Invalid left part of the percentage" [ fromInt, fromFloatString ".", fromFloatString "," ] number
            |> Result.map (multiply (rational 1 100))

    else
        Err "Invalid percentage"


fromString : String -> Result String Rational
fromString s =
    oneOf "Invalid number. It should look like an integer, float, rational or percentage"
        [ fromInt
        , fromSlashString
        , fromFloatString "."
        , fromFloatString ","
        , fromPercent
        ]
        s


oneOf : String -> List (String -> Result String Rational) -> String -> Result String Rational
oneOf error ds s =
    -- return the first successful result using a list of rational decoders
    case ds of
        [] ->
            Err error

        first :: rest ->
            case first s of
                Ok r ->
                    Ok r

                Err _ ->
                    oneOf error rest s


toString : Rational -> String
toString r =
    String.fromInt r.numerator
        ++ (if r.denominator == 1 then
                ""

            else
                "/" ++ String.fromInt r.denominator
           )


toFloatString : Rational -> String
toFloatString r =
    String.fromFloat (toFloat r.numerator / toFloat r.denominator)


resultToString : Result String Rational -> String
resultToString result =
    case result of
        Ok r ->
            toString r

        Err err ->
            err


parse : String -> String
parse =
    fromString >> resultToString
