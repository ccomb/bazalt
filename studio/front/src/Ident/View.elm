module Ident.View exposing (displayIdentifierDict)

import Dict exposing (Dict)
import Element exposing (Element, fill, none, shrink, table, text, width)
import Element.Background as Background
import Ident.Identifier as Identifier
import Ontology.Ident.Identifier exposing (Identifier)
import View.Style exposing (color)
import View.Table exposing (innerCell)


displayIdentifierDict : String -> Dict String Identifier -> Element msg
displayIdentifierDict default data =
    -- TODO move closer from where it's used?
    if not (Dict.isEmpty data) then
        table [ width shrink, Background.color color.item.background ]
            { data = Dict.values data
            , columns =
                [ { header = none, width = fill, view = .name >> innerCell }
                , { header = none, width = fill, view = Identifier.toValue >> innerCell }
                ]
            }

    else
        text default
