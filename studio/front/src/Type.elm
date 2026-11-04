module Type exposing (compare, hasCommonParent, isChildOf, isParentOf, toDisplay, toHierarchic, toPluralDisplay, toString, toType, userTypeOf)

import Dict exposing (Dict)
import Hierarchy.Type as HType
import Ontology.Hierarchy.Type as HType
import Ontology.Type exposing (Type(..))
import Ontology.Typed.Type as TType
import Prng.Uuid as Uuid exposing (Uuid)
import Typed.Type as TType
import Util exposing (third)


toDisplay : Type -> String
toDisplay t =
    case t of
        TType tt ->
            TType.toDisplay tt

        HType ht ->
            HType.toDisplay ht


toString : Type -> String
toString t =
    case t of
        TType tt ->
            TType.toString tt

        HType ht ->
            HType.toString ht


toPluralDisplay : Type -> String
toPluralDisplay t =
    case t of
        TType tt ->
            TType.toPluralDisplay tt

        HType ht ->
            HType.toPluralDisplay ht


toHierarchic : Type -> Type
toHierarchic t =
    case t of
        TType tt ->
            HType (TType.toHierarchic tt)

        HType ht ->
            HType ht


compare : Type -> String
compare =
    toString


userTypeOf : Dict String ( Uuid, Type, Maybe Uuid ) -> Uuid -> Maybe Uuid
userTypeOf types uuid =
    Dict.get (Uuid.toString uuid) types |> Maybe.andThen third


isChildOf : Dict String ( Uuid, Type, Maybe Uuid ) -> Uuid -> Uuid -> Bool
isChildOf types parent uuid =
    if uuid == parent then
        True

    else
        Dict.get (Uuid.toString uuid) types
            |> Maybe.andThen third
            |> Maybe.map
                (\puuid ->
                    if parent == puuid then
                        True

                    else
                        isChildOf types parent puuid
                )
            |> Maybe.withDefault False


isParentOf : Dict String ( Uuid, Type, Maybe Uuid ) -> Uuid -> Uuid -> Bool
isParentOf types uuid parent =
    isChildOf types parent uuid


parents : Uuid -> Dict String ( Uuid, Type, Maybe Uuid ) -> List Uuid -> List Uuid
parents uuid items currents =
    -- TODO merge with Tree.parents
    Dict.get (Uuid.toString uuid) items
        |> Maybe.andThen third
        |> Maybe.map (\parent -> parents parent items (parent :: currents))
        |> Maybe.withDefault currents


hasCommonParent : Dict String ( Uuid, Type, Maybe Uuid ) -> Uuid -> Uuid -> Bool
hasCommonParent types uuid1 uuid2 =
    not <|
        Dict.isEmpty <|
            Dict.intersect
                (Dict.fromList <| List.map (\uuid -> ( Uuid.toString uuid, uuid )) <| parents uuid1 types [])
                (Dict.fromList <| List.map (\uuid -> ( Uuid.toString uuid, uuid )) <| parents uuid2 types [])


toType : Type -> Type
toType t =
    case t of
        TType TType.Resource ->
            HType HType.ResourceType

        TType TType.Event ->
            HType HType.EventType

        TType TType.Agent ->
            HType HType.AgentType

        TType TType.Commitment ->
            HType HType.CommitmentType

        TType TType.Contract ->
            HType HType.ContractType

        TType TType.Process ->
            HType HType.ProcessType

        TType TType.Group ->
            HType HType.GroupType

        _ ->
            t
