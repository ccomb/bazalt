module Expression.Binary exposing (all, eval, toShortString, toString)

import Expression.Rational as R exposing (Rational)
import Ontology.Expression.Binary exposing (Operator(..))
import Util exposing (otherwiseR)


toString : Operator -> String
toString o =
    case o of
        Add ->
            "Add"

        Multiply ->
            "Multiply"

        Or _ ->
            "Or"

        Otherwise ->
            "Otherwise"


eval : Operator -> Result String Rational -> Result String Rational -> Result String Rational
eval operator res1 res2 =
    case operator of
        Add ->
            Result.map2 R.add res1 res2

        Multiply ->
            Result.map2 R.multiply res1 res2

        Or data ->
            -- one can choose either even if one fails
            data.choice
                |> Result.fromMaybe "No choice made"
                |> Result.andThen
                    (\c ->
                        if c then
                            res1

                        else
                            res2
                    )

        Otherwise ->
            res1 |> otherwiseR res2


or : String -> String -> Maybe Bool -> Operator
or n d c =
    Or { name = n, desc = d, choice = c }


toShortString : Operator -> String
toShortString o =
    case o of
        Add ->
            " + "

        Multiply ->
            " × "

        Or _ ->
            " or "

        Otherwise ->
            " ?? Otherwise: "


all : List Operator
all =
    [ Add, Multiply, or "" "" Nothing, Otherwise ]
