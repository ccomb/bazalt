module Configuration.View exposing (description, view)

import Configuration.Zone as Zone
import Configuration.Zone.Fragment as Fragment
import Configuration.Zone.View exposing (displayZone)
import Hierarchy.Type as HType
import Ontology.Configuration exposing (Configuration(..))
import Ontology.Configuration.Zone exposing (Zone(..))
import Ontology.Type as Type
import Prng.Uuid as Uuid
import Scope.View
import Shared


view : Configuration -> String
view c =
    -- TODO convert to a separate title and description to feed in to a smallcard
    case c of
        ZoneDisplay display ->
            Zone.toDesc display.zone
                ++ " : "
                ++ (String.concat <| List.map Fragment.toString display.fragments)

        MenuDisplay display ->
            HType.toString display.what
                ++ " "
                ++ Uuid.toString display.uuid
                ++ ": "
                ++ (if display.isMenu then
                        "visible"

                    else
                        "not visible"
                   )


description : Shared.Model -> Configuration -> String
description s c =
    case c of
        ZoneDisplay display ->
            Scope.View.toDisplay s.state display.scope

        MenuDisplay display ->
            displayZone s.state SmallcardZone (Type.HType display.what) display.uuid
                ++ ": "
                ++ (if display.isMenu then
                        "visible"

                    else
                        "not visible"
                   )
