module Configuration.Zone.View exposing (displayZone)

import Configuration as Config
import Dict
import Expression.Eval as Eval
import Expression.Rational as Rational
import Group.Group as Group
import Ident.Identifier as Identifier
import Ontology.Configuration exposing (Configuration(..))
import Ontology.Configuration.Zone exposing (Zone)
import Ontology.Configuration.Zone.Fragment exposing (Fragment(..))
import Ontology.Flow exposing (Flow(..))
import Ontology.Hierarchy.Type as HType
import Ontology.Scope exposing (Scope(..))
import Ontology.Type as Type exposing (Type)
import Ontology.Typed.Type as TType
import Prng.Uuid as Uuid exposing (Uuid)
import State exposing (State)
import Util exposing (ifEmpty)


displayZone : State -> Zone -> Type -> Uuid -> String
displayZone s zone t uuid =
    -- TODO replace types configs allIds allGroupLinks with just s
    Config.getMostSpecific s.types s.configs zone (IsItem t uuid)
        |> Maybe.map
            (\conf ->
                case conf of
                    ZoneDisplay display ->
                        String.concat <| List.map (toValue s t uuid zone) display.fragments

                    _ ->
                        ""
            )
        |> Maybe.withDefault (Uuid.toString uuid)


flowZone : State -> Zone -> Flow -> String
flowZone s zone f =
    case f of
        ResourceFlow resource ->
            displayZone s zone (Type.TType TType.Resource) resource.uuid

        ResourceTypeFlow resourceType ->
            displayZone s zone (Type.HType HType.ResourceType) resourceType.uuid


toValue : State -> Type -> Uuid -> Zone -> Fragment -> String
toValue s t uuid zone fragment =
    case fragment of
        IdentifierName identifier ->
            Identifier.select identifier.name (Identifier.fromUuid uuid s.identifiers) |> List.map Identifier.toValue |> String.join ", "

        GroupIdentifierName groupidentifier ->
            let
                groupids =
                    Group.groupsOf s.grouped uuid |> List.concatMap (\guuid -> Identifier.fromUuid guuid s.identifiers |> Dict.toList) |> Dict.fromList
            in
            Identifier.select groupidentifier.name groupids |> List.map Identifier.toValue |> String.join ", "

        Parent ->
            let
                parent =
                    Dict.get (Uuid.toString uuid) s.groups |> Maybe.andThen .parent
            in
            Maybe.map (displayZone s zone (Type.TType TType.Group)) parent |> Maybe.withDefault ""

        Fixed fixed ->
            fixed.string

        Quantity ->
            case t of
                Type.TType TType.Commitment ->
                    Dict.get (Uuid.toString uuid) s.commitments
                        |> Maybe.map (.qty >> Eval.exeval s { context = ( t, uuid ) } s.values >> Rational.resultToString)
                        |> Maybe.withDefault ""

                _ ->
                    ""

        Flow ->
            (case t of
                Type.TType TType.Commitment ->
                    Dict.get (Uuid.toString uuid) s.commitments
                        |> Maybe.map (.flow >> flowZone s zone)

                Type.TType TType.Event ->
                    Dict.get (Uuid.toString uuid) s.events
                        |> Maybe.map (.flow >> flowZone s zone)

                _ ->
                    Nothing
            )
                |> Maybe.withDefault ""

        Provider ->
            case t of
                Type.TType TType.Commitment ->
                    Dict.get (Uuid.toString uuid) s.commitments
                        |> Maybe.map
                            (.provider
                                >> displayZone s zone (Type.TType TType.Agent)
                            )
                        |> Maybe.withDefault ""

                Type.TType TType.Event ->
                    Dict.get (Uuid.toString uuid) s.events
                        |> Maybe.map
                            (.provider
                                >> displayZone s zone (Type.TType TType.Agent)
                            )
                        |> Maybe.withDefault ""

                _ ->
                    ""

        Receiver ->
            case t of
                Type.TType TType.Commitment ->
                    Dict.get (Uuid.toString uuid) s.commitments
                        |> Maybe.map
                            (.receiver
                                >> displayZone s zone (Type.TType TType.Agent)
                            )
                        |> Maybe.withDefault ""

                Type.TType TType.Event ->
                    Dict.get (Uuid.toString uuid) s.events
                        |> Maybe.map
                            (.receiver
                                >> displayZone s zone (Type.TType TType.Agent)
                            )
                        |> Maybe.withDefault ""

                _ ->
                    ""

        EventList separator ->
            case t of
                Type.TType TType.Process ->
                    Dict.filter (\_ r -> r.process == uuid) s.reconciliations
                        |> Dict.values
                        |> List.map (\r -> Rational.toFloatString r.qty ++ separator.qtySep ++ displayZone s zone (Type.TType TType.Event) r.event)
                        |> String.join separator.eventSep
                        |> ifEmpty "(empty)"

                _ ->
                    ""
