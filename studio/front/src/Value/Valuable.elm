module Value.Valuable exposing (getValues)

import Dict exposing (Dict)
import Ontology.Type exposing (Type)
import Ontology.Value.Value exposing (Value)
import Ontology.Value.ValueType exposing (ValueType)
import Prng.Uuid exposing (Uuid)
import Value.Value as Value
import Value.ValueType exposing (initValues)


getValues : Dict String ( Uuid, Type, Maybe Uuid ) -> Dict String ValueType -> Dict String Value -> Type -> Uuid -> Maybe Uuid -> Bool -> Dict String Value
getValues types allVts allVs t uuid mpuuid isNew =
    -- start with empty identifiers from identifierTypes, then merge with existing identifiers
    initValues types allVts t mpuuid uuid isNew
        |> Dict.union (Value.fromUuid uuid allVs)
