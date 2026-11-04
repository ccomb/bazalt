module Resource.Resource exposing (compare, resourceOf)

import Dict exposing (Dict)
import Ontology.Flow exposing (Flow(..))
import Ontology.Resource.Resource exposing (Resource)
import Prng.Uuid as Uuid exposing (Uuid)


compare : Resource -> String
compare =
    -- what allows to distinguish two resources?
    -- currently it's the uuid.
    -- Maybe in the future we can allow the identifiers to play that role
    .uuid >> Uuid.toString


resourceOf : Dict String { a | flow : Flow } -> Dict String Resource -> Uuid -> List Uuid
resourceOf entities resources uuid =
    -- the resource flowing in the entity, if it is a resource and not a resource type
    Dict.get (Uuid.toString uuid) entities
        |> Maybe.map
            (\e ->
                case e.flow of
                    ResourceFlow r ->
                        resources
                            |> Dict.filter (\_ v -> v.uuid == r.uuid)
                            |> Dict.values
                            |> List.map .uuid

                    ResourceTypeFlow _ ->
                        []
            )
        |> Maybe.withDefault []
