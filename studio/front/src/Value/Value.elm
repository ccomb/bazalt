module Value.Value exposing (compare, fromUuid, getByUuid)

import Dict exposing (Dict)
import Ontology.Value.Value exposing (Value)
import Prng.Uuid as Uuid exposing (Uuid)
import Type


compare : Value -> String
compare v =
    Type.compare v.what ++ "/" ++ Uuid.toString v.for ++ "/" ++ v.name


fromUuid : Uuid -> Dict String Value -> Dict String Value
fromUuid uuid =
    -- TODO rename to filterUuid
    Dict.filter (\_ v -> uuid == v.for)


getByUuid : Uuid -> Dict String Value -> Result String Value
getByUuid uuid all =
    fromUuid uuid all
        |> Dict.values
        |> List.head
        |> Result.fromMaybe "Missing value"
