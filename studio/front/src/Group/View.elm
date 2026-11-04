module Group.View exposing (displayGroupTable)

import Element exposing (Element, fill, shrink, table, text, width)
import Element.Background as Background
import View.Style exposing (color)
import View.Table exposing (headerCell, innerCell)


displayGroupTable : String -> List String -> Element msg
displayGroupTable default groups =
    if not (List.isEmpty groups) then
        table [ width shrink, Background.color color.item.background ]
            { data = groups
            , columns =
                [ { header = headerCell color.table.header.background2 "Groups", width = fill, view = innerCell }
                ]
            }

    else
        text default
