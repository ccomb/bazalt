module Ontology.Prim exposing
    ( Rational
    , posixDecoder
    , posixEncoder
    , rationalDecoder
    , rationalEncoder
    )

{-| JSON codecs of the primitive types the generated ontology relies on.
They follow the encoding of Haskell's aeson: an instant is a number of
seconds, a rational is its numerator and denominator. Everything else under
`Ontology` is generated from the Haskell types and never edited by hand.
-}

import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode
import Time


{-| An exact fraction. Both parts stay within ±2^53, the integers a
JavaScript number holds exactly.
-}
type alias Rational =
    { numerator : Int, denominator : Int }


posixEncoder : Time.Posix -> Encode.Value
posixEncoder t =
    Encode.float (toFloat (Time.posixToMillis t) / 1000)


posixDecoder : Decoder Time.Posix
posixDecoder =
    Decode.map (\s -> Time.millisToPosix (round (s * 1000))) Decode.float


rationalEncoder : Rational -> Encode.Value
rationalEncoder r =
    Encode.object [ ( "numerator", Encode.int r.numerator ), ( "denominator", Encode.int r.denominator ) ]


rationalDecoder : Decoder Rational
rationalDecoder =
    Decode.map2 Rational (Decode.field "numerator" exactInt) (Decode.field "denominator" exactInt)


{-| An integer that a JavaScript number holds exactly; a larger one would be
silently rounded, so it is refused.
-}
exactInt : Decoder Int
exactInt =
    Decode.int
        |> Decode.andThen
            (\n ->
                if abs n > 9007199254740992 then
                    Decode.fail ("integer beyond ±2^53, not exact in JavaScript: " ++ String.fromInt n)

                else
                    Decode.succeed n
            )
