module Group.Group exposing (groupsOf)

import Dict exposing (Dict)
import Ontology.Group.Link as GroupLink
import Prng.Uuid exposing (Uuid)


groupsOf : Dict String GroupLink.Link -> Uuid -> List Uuid
groupsOf links uuid =
    links
        |> Dict.filter (\_ link -> link.groupable == uuid)
        |> Dict.values
        |> List.map .group
