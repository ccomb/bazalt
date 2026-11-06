module Agent.Agent exposing (providerOf, providersOf, receiverOf, receiversOf)

import Dict exposing (Dict)
import Ontology.Agent.Agent exposing (Agent)
import Ontology.Scope exposing (Scope(..))
import Ontology.Type as Type exposing (Type)
import Ontology.Typed.Type as TType
import Prng.Uuid as Uuid exposing (Uuid)
import Scope.State as Scope


providersOf : Dict String ( Uuid, Type, Maybe Uuid ) -> Dict String { a | providers : Scope } -> Dict String Agent -> Uuid -> List Uuid
providersOf types entities agents uuid =
    Dict.get (Uuid.toString uuid) entities
        |> Maybe.map
            (\e ->
                agents
                    |> Dict.filter (\_ v -> Scope.containsScope types (IsItem (Type.TType TType.Agent) v.uuid) e.providers)
                    |> Dict.values
                    |> List.map .uuid
            )
        |> Maybe.withDefault []


receiversOf : Dict String ( Uuid, Type, Maybe Uuid ) -> Dict String { a | receivers : Scope } -> Dict String Agent -> Uuid -> List Uuid
receiversOf types entities agents uuid =
    Dict.get (Uuid.toString uuid) entities
        |> Maybe.map
            (\e ->
                agents
                    |> Dict.filter (\_ v -> Scope.containsScope types (IsItem (Type.TType TType.Agent) v.uuid) e.receivers)
                    |> Dict.values
                    |> List.map .uuid
            )
        |> Maybe.withDefault []


providerOf : Dict String { a | provider : Uuid } -> Dict String Agent -> Uuid -> List Uuid
providerOf entities agents uuid =
    Dict.get (Uuid.toString uuid) entities
        |> Maybe.map
            (\e ->
                agents
                    |> Dict.filter (\_ v -> v.uuid == e.provider)
                    |> Dict.values
                    |> List.map .uuid
            )
        |> Maybe.withDefault []


receiverOf : Dict String { a | receiver : Uuid } -> Dict String Agent -> Uuid -> List Uuid
receiverOf entities agents uuid =
    Dict.get (Uuid.toString uuid) entities
        |> Maybe.map
            (\e ->
                agents
                    |> Dict.filter (\_ v -> v.uuid == e.receiver)
                    |> Dict.values
                    |> List.map .uuid
            )
        |> Maybe.withDefault []
