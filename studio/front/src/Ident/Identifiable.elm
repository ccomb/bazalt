module Ident.Identifiable exposing (getIdentifiers)

import Dict exposing (Dict)
import Ident.Identifier as Identifier
import Ident.IdentifierType exposing (initIdentifiers)
import Ontology.Ident.Identifier exposing (Identifier)
import Ontology.Type exposing (Type)
import Prng.Uuid exposing (Uuid)
import State exposing (State)



-- TODO move to somewhere else (see the same for Value) and remove this module
-- TODO or restore a separated Identifiable type?


getIdentifiers : State -> Type -> Uuid -> Maybe Uuid -> Bool -> Dict String Identifier
getIdentifiers s t uuid mpuuid isNew =
    -- start with empty identifiers from identifierTypes, then merge with existing identifiers
    initIdentifiers s.types s.identifierTypes t mpuuid uuid isNew
        |> Dict.union (Identifier.fromUuid uuid s.identifiers)
