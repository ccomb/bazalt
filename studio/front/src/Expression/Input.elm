module Expression.Input exposing (Config, inputExpression)

import Element exposing (Element, fill, height, htmlAttribute, row, text)
import Expression
import Expression.Binary as B
import Expression.Eval as Eval
import Expression.Rational as Rational
import Expression.RationalInput as RationalInput
import Expression.Unary as U
import Html.Attributes as Attr
import Ontology.Expression exposing (Expression(..))
import Ontology.Expression.Observable exposing (Observable(..))
import Ontology.Expression.ValueSelection as ValueSelection
import Ontology.Type exposing (Type)
import Prng.Uuid exposing (Uuid)
import State exposing (State)
import Util exposing (chooseIfSingleton)
import Value.Value as Value


type alias Config msg =
    { onEnter : msg
    , onInput : Expression -> msg
    , context : ( Type, Uuid )
    }


inputExpression : Config msg -> State -> ( List Int, Expression ) -> Expression -> Element msg
inputExpression c s ( currentPath, currentExpr ) expr =
    -- used to input values into an expression
    -- put currentExpr at currentPath in expr
    case currentExpr of
        Leaf obs ->
            inputObservable c s currentPath obs expr

        Unary unary ->
            row [] [ text (U.toShortString unary.uop), inputExpression c s ( 1 :: currentPath, unary.expr ) expr ]

        Binary binary ->
            row [] [ text "( ", inputExpression c s ( 2 :: currentPath, binary.expr1 ) expr, text <| B.toShortString binary.bop, inputExpression c s ( 3 :: currentPath, binary.expr2 ) expr, text " )" ]


inputObservable : Config msg -> State -> List Int -> Observable -> Expression -> Element msg
inputObservable c s targetPath obs expr =
    case obs of
        Constant n ->
            text n

        Variable n ->
            RationalInput.inputText
                Rational.fromString
                ((targetPath |> List.map String.fromInt) ++ [ n.name ] |> String.join "/")
                (Just n.name)
                (\str -> c.onInput <| Expression.updateExpr targetPath [] (Leaf <| Variable { n | input = str }) expr)
                n.input

        ObsValue (ValueSelection.SelectedValue sv) ->
            row [ height fill, htmlAttribute <| Attr.title sv.name ]
                [ text <|
                    case
                        Value.getByUuid sv.for s.values
                            |> Result.andThen (Eval.veval s { context = c.context } s.values)
                    of
                        Err err ->
                            err

                        Ok r ->
                            Rational.toString r
                ]

        ObsValue ValueSelection.UndefinedValue ->
            row [ height fill ] [ text "Unselected value" ]

        ObsLink deeplink ->
            let
                value =
                    Eval.dleval s deeplink [ Tuple.second c.context ]
                        |> chooseIfSingleton
                        |> Maybe.map (Eval.veval s { context = c.context } s.values)
            in
            row [ height fill ]
                [ value
                    |> Maybe.map
                        (\result ->
                            case
                                result
                            of
                                Err err ->
                                    err

                                Ok r ->
                                    Rational.toString r
                        )
                    |> Maybe.withDefault "EMPTY RESULT"
                    |> text
                ]
