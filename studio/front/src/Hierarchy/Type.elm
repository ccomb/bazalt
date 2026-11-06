module Hierarchy.Type exposing (all, compare, toDisplay, toPluralDisplay, toString)

import Ontology.Hierarchy.Type exposing (Type(..))


all : List Type
all =
    [ ResourceType, EventType, AgentType, CommitmentType, ContractType, ProcessType, GroupType ]


toDisplay : Type -> String
toDisplay t =
    case t of
        ResourceType ->
            "Resource Type"

        EventType ->
            "Event Type"

        AgentType ->
            "Agent Type"

        CommitmentType ->
            "Commitment Type"

        ContractType ->
            "Contract Type"

        ProcessType ->
            "Process Type"

        GroupType ->
            "Group Type"


toString : Type -> String
toString t =
    toDisplay t |> String.split " " |> String.concat


compare : Type -> String
compare =
    toString


toPluralDisplay : Type -> String
toPluralDisplay t =
    -- TODO not i18n friendly
    toDisplay t ++ "s"
