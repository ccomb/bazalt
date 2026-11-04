module Value.View exposing (displayValueDict)

import Dict exposing (Dict)
import Element exposing (Element, fill, none, shrink, table, text, width)
import Element.Background as Background
import Expression.Eval as Eval
import Expression.Rational as Rational
import Ontology.Value.Value exposing (Value)
import Shared
import View.Style exposing (color)
import View.Table exposing (innerCell)


displayValueDict : Shared.Model -> Eval.Config -> String -> Dict String Value -> Dict String Value -> Element msg
displayValueDict s c default allV data =
    if not (Dict.isEmpty data) then
        table [ width shrink, Background.color color.item.background ]
            { data = Dict.values data
            , columns =
                [ { header = none, width = fill, view = .name >> innerCell }
                , { header = none
                  , width = fill
                  , view =
                        .expr
                            >> Eval.exeval s.state c allV
                            >> Result.map Rational.toFloatString
                            >> Result.withDefault "(undefined)"
                            >> innerCell
                  }
                ]
            }

    else
        text default
