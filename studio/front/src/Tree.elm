module Tree exposing (all, isDirectChildOf, parentOf, toString)

import Dict exposing (Dict)
import Ontology.Tree exposing (TreeType(..))
import Prng.Uuid as Uuid exposing (Uuid)


isDirectChildOf : Dict String { a | parent : Maybe Uuid } -> Uuid -> Uuid -> Bool
isDirectChildOf items parent uuid =
    Dict.get (Uuid.toString uuid) items
        |> Maybe.andThen .parent
        |> Maybe.map ((==) parent)
        |> Maybe.withDefault False


parentOf : Dict String { a | parent : Maybe Uuid } -> Uuid -> Maybe Uuid
parentOf entities uuid =
    Dict.get (Uuid.toString uuid) entities |> Maybe.andThen .parent


all : List TreeType
all =
    [ Flat, Node, Leaf ]


toString : TreeType -> String
toString t =
    case t of
        Flat ->
            "Not hierarchical"

        Node ->
            "Hierarchical, an intermediate node can be selected"

        Leaf ->
            "Hierarchical, a leaf must be selected"
