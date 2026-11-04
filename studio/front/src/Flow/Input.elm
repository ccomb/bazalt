module Flow.Input exposing (Config, input)

import Dict
import Element exposing (Element, alignTop, centerY, column, el, fill, minimum, none, padding, spacing, text, width, wrappedRow)
import Element.Background as Background
import Ontology.Flow exposing (Flow(..))
import Ontology.Scope exposing (Scope(..))
import Ontology.Type as Type
import Scope.State exposing (containsScope)
import Shared
import View exposing (h2, p, withDefaultContent)
import View.Smallcard exposing (tClickableCard, viewHalfCard)
import View.Style exposing (color)


type alias Config msg =
    { flow : Maybe Flow
    , scope : Scope
    , onSelect : Maybe Flow -> msg
    , onEnter : msg
    }


input : Config msg -> Shared.Model -> ( Element msg, Element msg )
input c s =
    -- (chosen, choice)
    ( c.flow
        |> Maybe.map
            (\flow ->
                case flow of
                    ResourceFlow r ->
                        viewHalfCard s.state (Just <| c.onSelect Nothing) (Type.TType r.what) r.uuid

                    ResourceTypeFlow rt ->
                        viewHalfCard s.state (Just <| c.onSelect Nothing) (Type.HType rt.what) rt.uuid
            )
        |> Maybe.withDefault (el [ centerY ] <| text "Nothing chosen yet")
    , c.flow
        |> Maybe.map (always none)
        |> Maybe.withDefault
            (column [ spacing 10 ]
                [ column [ alignTop, padding 10, spacing 10, width <| minimum 200 fill, Background.color color.content.choice ]
                    [ h2 "Choose either a specific Resource:"
                    , wrappedRow [ padding 10, spacing 10 ]
                        (s.state.resources
                            |> Dict.filter (\_ r -> containsScope s.state.types (IsItem (Type.TType r.what) r.uuid) c.scope)
                            |> Dict.values
                            |> List.map (\r -> tClickableCard s.state (c.onSelect (Just <| ResourceFlow r)) (Type.TType r.what) r.uuid)
                            |> withDefaultContent (p "(No Resources to choose from)")
                        )
                    ]
                , column [ alignTop, padding 10, spacing 10, width <| minimum 200 fill, Background.color color.content.choice ]
                    [ h2 "Or a general Resource Type:"
                    , wrappedRow [ padding 10, spacing 10 ]
                        (s.state.resourceTypes
                            |> Dict.filter (\_ rt -> containsScope s.state.types (IsItem (Type.HType rt.what) rt.uuid) c.scope)
                            |> Dict.values
                            |> List.map (\rt -> tClickableCard s.state (c.onSelect (Just <| ResourceTypeFlow rt)) (Type.HType rt.what) rt.uuid)
                            |> withDefaultContent (p "(No Resource Types to choose from)")
                        )
                    ]
                ]
            )
    )
