module Typed.Type exposing (all, toDisplay, toHierarchic, toPluralDisplay, toString)

import Ontology.Hierarchy.Type as HType
import Ontology.Typed.Type exposing (Type(..))


all : List Type
all =
    [ Resource, Event, Agent, Commitment, Contract, Process, Group ]


toHierarchic : Type -> HType.Type
toHierarchic t =
    case t of
        Resource ->
            HType.ResourceType

        Event ->
            HType.EventType

        Agent ->
            HType.AgentType

        Commitment ->
            HType.CommitmentType

        Contract ->
            HType.ContractType

        Process ->
            HType.ProcessType

        Group ->
            HType.GroupType


toString : Type -> String
toString t =
    case t of
        Resource ->
            "Resource"

        Event ->
            "Event"

        Agent ->
            "Agent"

        Commitment ->
            "Commitment"

        Contract ->
            "Contract"

        Process ->
            "Process"

        Group ->
            "Group"


toDisplay : Type -> String
toDisplay =
    toString


toPluralDisplay : Type -> String
toPluralDisplay t =
    -- TODO not i18n friendly
    case t of
        Process ->
            "Processes"

        _ ->
            toDisplay t ++ "s"
