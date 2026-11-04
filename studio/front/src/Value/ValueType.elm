module Value.ValueType exposing (compare, initValues)

import Dict exposing (Dict)
import Ontology.Scope exposing (Scope(..))
import Ontology.Type exposing (Type)
import Ontology.Value.Value exposing (Value)
import Ontology.Value.ValueType exposing (ValueType)
import Prng.Uuid exposing (Uuid)
import Scope
import Scope.State exposing (containsScope)
import Value.Value as Value


initValues : Dict String ( Uuid, Type, Maybe Uuid ) -> Dict String ValueType -> Type -> Maybe Uuid -> Uuid -> Bool -> Dict String Value
initValues types vts t muuid uuid isNew =
    -- build the empty values corresponding to the chosen type, possible user type, and uuid of the added/edited entity
    -- if uuid is a newly generated one, we only have the Agent type t, the selected parent type and No uuid.
    -- So we must find all the vt whose scope is ascendent of (HasUserType t h.uuid).
    vts
        |> Dict.filter
            (\_ vt ->
                if isNew then
                    containsScope types
                        (Maybe.map (HasUserType t) muuid
                            |> Maybe.withDefault (HasType t)
                        )
                        vt.scope

                else
                    containsScope types (IsItem t uuid) vt.scope
            )
        |> Dict.values
        |> List.map
            (\vt ->
                let
                    i =
                        Value t uuid vt.name vt.expr
                in
                ( Value.compare i, i )
            )
        |> Dict.fromList


compare : ValueType -> String
compare vt =
    Scope.compare vt.scope ++ "/" ++ vt.name
