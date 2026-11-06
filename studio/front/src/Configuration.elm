module Configuration exposing (compare, getMostSpecific, onlyMenu)

import Configuration.Zone as Zone
import Dict exposing (Dict)
import Hierarchy.Type as HType
import Ontology.Configuration exposing (Configuration(..))
import Ontology.Configuration.Zone exposing (Zone)
import Ontology.Scope exposing (Scope)
import Ontology.Type exposing (Type)
import Prng.Uuid as Uuid exposing (Uuid)
import Scope
import Scope.State exposing (getUpperList)


onlyMenu : Dict String Configuration -> Dict String Configuration
onlyMenu confs =
    confs
        |> Dict.filter
            (\_ v ->
                case v of
                    MenuDisplay _ ->
                        True

                    _ ->
                        False
            )


getConfig : Zone -> Dict String Configuration -> Scope -> Maybe Configuration
getConfig requestedZone configs scope =
    -- find the first ZoneDisplay config that correspond exactly to the scope
    List.head <|
        Dict.values <|
            Dict.filter
                (\_ conf ->
                    case conf of
                        ZoneDisplay display ->
                            display.zone == requestedZone && display.scope == scope

                        _ ->
                            False
                )
                configs


getMostSpecific : Dict String ( Uuid, Type, Maybe Uuid ) -> Dict String Configuration -> Zone -> Scope -> Maybe Configuration
getMostSpecific types configs zone scope =
    -- returns the most specific config for a given zone and scope
    findFirst zone configs (List.reverse <| getUpperList types scope [])


findFirst : Zone -> Dict String Configuration -> List Scope -> Maybe Configuration
findFirst zone configs scopes =
    -- from a list of upperScopes, find the first one for which a config exists
    scopes
        |> List.head
        |> Maybe.andThen
            (\firstScope ->
                case getConfig zone configs firstScope of
                    Nothing ->
                        List.tail scopes
                            |> Maybe.andThen (findFirst zone configs)

                    Just config ->
                        Just config
            )


compare : Configuration -> String
compare config =
    case config of
        ZoneDisplay display ->
            "ZoneDisplay/" ++ Zone.compare display.zone ++ "/" ++ Scope.compare display.scope

        MenuDisplay display ->
            "MenuDisplay/" ++ HType.compare display.what ++ "/" ++ Uuid.toString display.uuid
