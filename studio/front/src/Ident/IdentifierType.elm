module Ident.IdentifierType exposing (compare, initIdentifiers)

import Dict exposing (Dict)
import Ident.Identifier as Identifier
import Ontology.Ident.Identifier exposing (Identifier)
import Ontology.Ident.IdentifierType exposing (IdentifierType)
import Ontology.Scope exposing (Scope(..))
import Ontology.Type exposing (Type)
import Prng.Uuid exposing (Uuid)
import Scope
import Scope.State exposing (containsScope)


initIdentifiers : Dict String ( Uuid, Type, Maybe Uuid ) -> Dict String IdentifierType -> Type -> Maybe Uuid -> Uuid -> Bool -> Dict String Identifier
initIdentifiers types its t muuid uuid isNew =
    {- build the empty identifiers corresponding to the chosen type, possible user type, and uuid of the added/edited entity
       if uuid is a newly generated one, we only have the Agent type t, the selected parent type and No uuid.
       So we must find all the it whose scope is ascendent of (HasUserType t h.what h.uuid).
    -}
    (its
        |> Dict.filter
            (\_ it ->
                if isNew then
                    containsScope types
                        (Maybe.map (HasUserType t) muuid
                            |> Maybe.withDefault (HasType t)
                        )
                        it.scope

                else
                    containsScope types (IsItem t uuid) it.scope
            )
    )
        |> Dict.values
        |> List.map
            (\it ->
                let
                    i =
                        Identifier t uuid it.name it.fragments
                in
                ( Identifier.compare i, i )
            )
        |> Dict.fromList


compare : IdentifierType -> String
compare it =
    Scope.compare it.scope ++ "/" ++ it.name
