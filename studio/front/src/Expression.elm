module Expression exposing (applyBinary, applyUnary, swap, undo, updateExpr)

import Ontology.Expression exposing (Expression(..))
import Ontology.Expression.Binary as B
import Ontology.Expression.Unary as U


applyBinary : B.Operator -> List Expression -> List Expression
applyBinary o stack =
    Maybe.map3 (\f s t -> Binary { bop = o, expr1 = f, expr2 = s } :: t) (List.head stack) (Maybe.andThen List.head <| List.tail stack) (Maybe.andThen List.tail <| List.tail stack) |> Maybe.withDefault []


applyUnary : U.Operator -> List Expression -> List Expression
applyUnary o stack =
    Maybe.map2 (\h t -> Unary { uop = o, expr = h } :: t) (List.head stack) (List.tail stack) |> Maybe.withDefault []


updateExpr : List Int -> List Int -> Expression -> Expression -> Expression
updateExpr targetPath currentPath subExpr expr =
    -- we replace the expr at the given path
    case expr of
        Leaf _ ->
            if currentPath == targetPath then
                subExpr

            else
                expr

        Unary unary ->
            Unary { uop = unary.uop, expr = updateExpr targetPath (1 :: currentPath) subExpr unary.expr }

        Binary binary ->
            Binary { bop = binary.bop, expr1 = updateExpr targetPath (2 :: currentPath) subExpr binary.expr1, expr2 = updateExpr targetPath (3 :: currentPath) subExpr binary.expr2 }


undo : List Expression -> List Expression
undo stack =
    (List.head stack
        |> Maybe.map
            (\expr ->
                case expr of
                    Leaf _ ->
                        []

                    Unary unary ->
                        [ unary.expr ]

                    Binary binary ->
                        [ binary.expr1, binary.expr2 ]
            )
        |> Maybe.withDefault []
    )
        ++ (List.tail stack |> Maybe.withDefault [])


swap : List Expression -> List Expression
swap stack =
    -- swap the two first lines of the stack
    case stack of
        x :: xs ->
            case xs of
                y :: ys ->
                    y :: x :: ys

                _ ->
                    xs

        _ ->
            stack
