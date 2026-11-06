module Tree.View exposing (inputTreeType)

import Ontology.Tree as Tree
import Element exposing (Element, column, el, fill, padding, pointer, spacing, width, wrappedRow)
import Element.Background as Background
import Element.Events exposing (onClick)
import Tree
import View exposing (p)
import View.Style exposing (color)


inputTreeType : (Tree.TreeType -> msg) -> Tree.TreeType -> Element msg
inputTreeType onInput treetype =
    column [ spacing 5, width fill ] <|
        List.map
            (\t ->
                wrappedRow [ spacing 20 ]
                    [ el
                        [ pointer
                        , padding 10
                        , width fill
                        , Background.color <|
                            if t == treetype then
                                color.item.selected

                            else
                                color.item.background
                        , onClick (onInput t)
                        ]
                        (p <| Tree.toString t)
                    ]
            )
            Tree.all
