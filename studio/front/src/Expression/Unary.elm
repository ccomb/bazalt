module Expression.Unary exposing (all, eval, toShortString, toString)

import Expression.Rational as R exposing (Rational)
import Ontology.Expression.Unary exposing (Operator(..))


eval : Operator -> Rational -> Rational
eval op n =
    case op of
        Neg ->
            R.neg n

        Inv ->
            R.inv n


toString : Operator -> String
toString o =
    case o of
        Neg ->
            "Neg"

        Inv ->
            "Inv"


toShortString : Operator -> String
toShortString o =
    case o of
        Neg ->
            " - "

        Inv ->
            "1 / "


all : List Operator
all =
    [ Neg, Inv ]
