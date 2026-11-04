module Ontology.Hierarchy.Type exposing
    ( Type(..)
    , typeDecoder
    , typeEncoder
    )

import Json.Decode
import Json.Encode


type Type
    = ResourceType
    | EventType
    | AgentType
    | CommitmentType
    | ContractType
    | ProcessType
    | GroupType


typeEncoder : Type -> Json.Encode.Value
typeEncoder a =
    case a of
        ResourceType ->
            Json.Encode.string "ResourceType"

        EventType ->
            Json.Encode.string "EventType"

        AgentType ->
            Json.Encode.string "AgentType"

        CommitmentType ->
            Json.Encode.string "CommitmentType"

        ContractType ->
            Json.Encode.string "ContractType"

        ProcessType ->
            Json.Encode.string "ProcessType"

        GroupType ->
            Json.Encode.string "GroupType"


typeDecoder : Json.Decode.Decoder Type
typeDecoder =
    Json.Decode.string
        |> Json.Decode.andThen
            (\a ->
                case a of
                    "ResourceType" ->
                        Json.Decode.succeed ResourceType

                    "EventType" ->
                        Json.Decode.succeed EventType

                    "AgentType" ->
                        Json.Decode.succeed AgentType

                    "CommitmentType" ->
                        Json.Decode.succeed CommitmentType

                    "ContractType" ->
                        Json.Decode.succeed ContractType

                    "ProcessType" ->
                        Json.Decode.succeed ProcessType

                    "GroupType" ->
                        Json.Decode.succeed GroupType

                    _ ->
                        Json.Decode.fail "No matching constructor"
            )
