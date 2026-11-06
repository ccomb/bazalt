module Ontology.Expression.HardLink exposing
    ( AgentLink(..)
    , AgentTypeLink(..)
    , CommitmentLink(..)
    , CommitmentTypeLink(..)
    , ContractLink(..)
    , ContractTypeLink(..)
    , EventLink(..)
    , EventTypeLink(..)
    , GroupLink(..)
    , GroupTypeLink(..)
    , HardLink(..)
    , ProcessLink(..)
    , ProcessTypeLink(..)
    , ResourceLink(..)
    , ResourceTypeLink(..)
    , agentLinkDecoder
    , agentLinkEncoder
    , agentTypeLinkDecoder
    , agentTypeLinkEncoder
    , commitmentLinkDecoder
    , commitmentLinkEncoder
    , commitmentTypeLinkDecoder
    , commitmentTypeLinkEncoder
    , contractLinkDecoder
    , contractLinkEncoder
    , contractTypeLinkDecoder
    , contractTypeLinkEncoder
    , eventLinkDecoder
    , eventLinkEncoder
    , eventTypeLinkDecoder
    , eventTypeLinkEncoder
    , groupLinkDecoder
    , groupLinkEncoder
    , groupTypeLinkDecoder
    , groupTypeLinkEncoder
    , hardLinkDecoder
    , hardLinkEncoder
    , processLinkDecoder
    , processLinkEncoder
    , processTypeLinkDecoder
    , processTypeLinkEncoder
    , resourceLinkDecoder
    , resourceLinkEncoder
    , resourceTypeLinkDecoder
    , resourceTypeLinkEncoder
    )

import Json.Decode
import Json.Decode.Pipeline
import Json.Encode


type HardLink
    = ResourceLink ResourceLink
    | EventLink EventLink
    | AgentLink AgentLink
    | CommitmentLink CommitmentLink
    | ContractLink ContractLink
    | ProcessLink ProcessLink
    | GroupLink GroupLink
    | ResourceTypeLink ResourceTypeLink
    | EventTypeLink EventTypeLink
    | AgentTypeLink AgentTypeLink
    | CommitmentTypeLink CommitmentTypeLink
    | ContractTypeLink ContractTypeLink
    | ProcessTypeLink ProcessTypeLink
    | GroupTypeLink GroupTypeLink


hardLinkEncoder : HardLink -> Json.Encode.Value
hardLinkEncoder a =
    case a of
        ResourceLink b ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "ResourceLink" )
                , ( "value", resourceLinkEncoder b )
                ]

        EventLink b ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "EventLink" )
                , ( "value", eventLinkEncoder b )
                ]

        AgentLink b ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "AgentLink" )
                , ( "value", agentLinkEncoder b )
                ]

        CommitmentLink b ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "CommitmentLink" )
                , ( "value", commitmentLinkEncoder b )
                ]

        ContractLink b ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "ContractLink" )
                , ( "value", contractLinkEncoder b )
                ]

        ProcessLink b ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "ProcessLink" )
                , ( "value", processLinkEncoder b )
                ]

        GroupLink b ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "GroupLink" )
                , ( "value", groupLinkEncoder b )
                ]

        ResourceTypeLink b ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "ResourceTypeLink" )
                , ( "value", resourceTypeLinkEncoder b )
                ]

        EventTypeLink b ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "EventTypeLink" )
                , ( "value", eventTypeLinkEncoder b )
                ]

        AgentTypeLink b ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "AgentTypeLink" )
                , ( "value", agentTypeLinkEncoder b )
                ]

        CommitmentTypeLink b ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "CommitmentTypeLink" )
                , ( "value", commitmentTypeLinkEncoder b )
                ]

        ContractTypeLink b ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "ContractTypeLink" )
                , ( "value", contractTypeLinkEncoder b )
                ]

        ProcessTypeLink b ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "ProcessTypeLink" )
                , ( "value", processTypeLinkEncoder b )
                ]

        GroupTypeLink b ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "GroupTypeLink" )
                , ( "value", groupTypeLinkEncoder b )
                ]


hardLinkDecoder : Json.Decode.Decoder HardLink
hardLinkDecoder =
    Json.Decode.field "type" Json.Decode.string
        |> Json.Decode.andThen
            (\a ->
                case a of
                    "ResourceLink" ->
                        Json.Decode.succeed ResourceLink
                            |> Json.Decode.Pipeline.required "value" resourceLinkDecoder

                    "EventLink" ->
                        Json.Decode.succeed EventLink
                            |> Json.Decode.Pipeline.required "value" eventLinkDecoder

                    "AgentLink" ->
                        Json.Decode.succeed AgentLink
                            |> Json.Decode.Pipeline.required "value" agentLinkDecoder

                    "CommitmentLink" ->
                        Json.Decode.succeed CommitmentLink
                            |> Json.Decode.Pipeline.required "value" commitmentLinkDecoder

                    "ContractLink" ->
                        Json.Decode.succeed ContractLink
                            |> Json.Decode.Pipeline.required "value" contractLinkDecoder

                    "ProcessLink" ->
                        Json.Decode.succeed ProcessLink
                            |> Json.Decode.Pipeline.required "value" processLinkDecoder

                    "GroupLink" ->
                        Json.Decode.succeed GroupLink
                            |> Json.Decode.Pipeline.required "value" groupLinkDecoder

                    "ResourceTypeLink" ->
                        Json.Decode.succeed ResourceTypeLink
                            |> Json.Decode.Pipeline.required "value" resourceTypeLinkDecoder

                    "EventTypeLink" ->
                        Json.Decode.succeed EventTypeLink
                            |> Json.Decode.Pipeline.required "value" eventTypeLinkDecoder

                    "AgentTypeLink" ->
                        Json.Decode.succeed AgentTypeLink
                            |> Json.Decode.Pipeline.required "value" agentTypeLinkDecoder

                    "CommitmentTypeLink" ->
                        Json.Decode.succeed CommitmentTypeLink
                            |> Json.Decode.Pipeline.required "value" commitmentTypeLinkDecoder

                    "ContractTypeLink" ->
                        Json.Decode.succeed ContractTypeLink
                            |> Json.Decode.Pipeline.required "value" contractTypeLinkDecoder

                    "ProcessTypeLink" ->
                        Json.Decode.succeed ProcessTypeLink
                            |> Json.Decode.Pipeline.required "value" processTypeLinkDecoder

                    "GroupTypeLink" ->
                        Json.Decode.succeed GroupTypeLink
                            |> Json.Decode.Pipeline.required "value" groupTypeLinkDecoder

                    _ ->
                        Json.Decode.fail "No matching constructor"
            )


type ResourceLink
    = ResourceGroup
    | ResourceType


resourceLinkEncoder : ResourceLink -> Json.Encode.Value
resourceLinkEncoder a =
    case a of
        ResourceGroup ->
            Json.Encode.string "ResourceGroup"

        ResourceType ->
            Json.Encode.string "ResourceType"


resourceLinkDecoder : Json.Decode.Decoder ResourceLink
resourceLinkDecoder =
    Json.Decode.string
        |> Json.Decode.andThen
            (\a ->
                case a of
                    "ResourceGroup" ->
                        Json.Decode.succeed ResourceGroup

                    "ResourceType" ->
                        Json.Decode.succeed ResourceType

                    _ ->
                        Json.Decode.fail "No matching constructor"
            )


type EventLink
    = EventProvider
    | EventReceiver
    | EventInflow
    | EventOutflow
    | EventGroup
    | EventType


eventLinkEncoder : EventLink -> Json.Encode.Value
eventLinkEncoder a =
    case a of
        EventProvider ->
            Json.Encode.string "EventProvider"

        EventReceiver ->
            Json.Encode.string "EventReceiver"

        EventInflow ->
            Json.Encode.string "EventInflow"

        EventOutflow ->
            Json.Encode.string "EventOutflow"

        EventGroup ->
            Json.Encode.string "EventGroup"

        EventType ->
            Json.Encode.string "EventType"


eventLinkDecoder : Json.Decode.Decoder EventLink
eventLinkDecoder =
    Json.Decode.string
        |> Json.Decode.andThen
            (\a ->
                case a of
                    "EventProvider" ->
                        Json.Decode.succeed EventProvider

                    "EventReceiver" ->
                        Json.Decode.succeed EventReceiver

                    "EventInflow" ->
                        Json.Decode.succeed EventInflow

                    "EventOutflow" ->
                        Json.Decode.succeed EventOutflow

                    "EventGroup" ->
                        Json.Decode.succeed EventGroup

                    "EventType" ->
                        Json.Decode.succeed EventType

                    _ ->
                        Json.Decode.fail "No matching constructor"
            )


type AgentLink
    = AgentGroup
    | AgentType


agentLinkEncoder : AgentLink -> Json.Encode.Value
agentLinkEncoder a =
    case a of
        AgentGroup ->
            Json.Encode.string "AgentGroup"

        AgentType ->
            Json.Encode.string "AgentType"


agentLinkDecoder : Json.Decode.Decoder AgentLink
agentLinkDecoder =
    Json.Decode.string
        |> Json.Decode.andThen
            (\a ->
                case a of
                    "AgentGroup" ->
                        Json.Decode.succeed AgentGroup

                    "AgentType" ->
                        Json.Decode.succeed AgentType

                    _ ->
                        Json.Decode.fail "No matching constructor"
            )


type CommitmentLink
    = CommitmentProvider
    | CommitmentReceiver
    | CommitmentInflow
    | CommitmentOutflow
    | CommitmentGroup
    | CommitmentType


commitmentLinkEncoder : CommitmentLink -> Json.Encode.Value
commitmentLinkEncoder a =
    case a of
        CommitmentProvider ->
            Json.Encode.string "CommitmentProvider"

        CommitmentReceiver ->
            Json.Encode.string "CommitmentReceiver"

        CommitmentInflow ->
            Json.Encode.string "CommitmentInflow"

        CommitmentOutflow ->
            Json.Encode.string "CommitmentOutflow"

        CommitmentGroup ->
            Json.Encode.string "CommitmentGroup"

        CommitmentType ->
            Json.Encode.string "CommitmentType"


commitmentLinkDecoder : Json.Decode.Decoder CommitmentLink
commitmentLinkDecoder =
    Json.Decode.string
        |> Json.Decode.andThen
            (\a ->
                case a of
                    "CommitmentProvider" ->
                        Json.Decode.succeed CommitmentProvider

                    "CommitmentReceiver" ->
                        Json.Decode.succeed CommitmentReceiver

                    "CommitmentInflow" ->
                        Json.Decode.succeed CommitmentInflow

                    "CommitmentOutflow" ->
                        Json.Decode.succeed CommitmentOutflow

                    "CommitmentGroup" ->
                        Json.Decode.succeed CommitmentGroup

                    "CommitmentType" ->
                        Json.Decode.succeed CommitmentType

                    _ ->
                        Json.Decode.fail "No matching constructor"
            )


type ContractLink
    = ContractGroup
    | ContractType


contractLinkEncoder : ContractLink -> Json.Encode.Value
contractLinkEncoder a =
    case a of
        ContractGroup ->
            Json.Encode.string "ContractGroup"

        ContractType ->
            Json.Encode.string "ContractType"


contractLinkDecoder : Json.Decode.Decoder ContractLink
contractLinkDecoder =
    Json.Decode.string
        |> Json.Decode.andThen
            (\a ->
                case a of
                    "ContractGroup" ->
                        Json.Decode.succeed ContractGroup

                    "ContractType" ->
                        Json.Decode.succeed ContractType

                    _ ->
                        Json.Decode.fail "No matching constructor"
            )


type ProcessLink
    = ProcessGroup
    | ProcessType


processLinkEncoder : ProcessLink -> Json.Encode.Value
processLinkEncoder a =
    case a of
        ProcessGroup ->
            Json.Encode.string "ProcessGroup"

        ProcessType ->
            Json.Encode.string "ProcessType"


processLinkDecoder : Json.Decode.Decoder ProcessLink
processLinkDecoder =
    Json.Decode.string
        |> Json.Decode.andThen
            (\a ->
                case a of
                    "ProcessGroup" ->
                        Json.Decode.succeed ProcessGroup

                    "ProcessType" ->
                        Json.Decode.succeed ProcessType

                    _ ->
                        Json.Decode.fail "No matching constructor"
            )


type GroupLink
    = GroupGroup
    | GroupType
    | ParentGroup


groupLinkEncoder : GroupLink -> Json.Encode.Value
groupLinkEncoder a =
    case a of
        GroupGroup ->
            Json.Encode.string "GroupGroup"

        GroupType ->
            Json.Encode.string "GroupType"

        ParentGroup ->
            Json.Encode.string "ParentGroup"


groupLinkDecoder : Json.Decode.Decoder GroupLink
groupLinkDecoder =
    Json.Decode.string
        |> Json.Decode.andThen
            (\a ->
                case a of
                    "GroupGroup" ->
                        Json.Decode.succeed GroupGroup

                    "GroupType" ->
                        Json.Decode.succeed GroupType

                    "ParentGroup" ->
                        Json.Decode.succeed ParentGroup

                    _ ->
                        Json.Decode.fail "No matching constructor"
            )


type ResourceTypeLink
    = ResourceTypeGroup
    | ResourceTypeParent


resourceTypeLinkEncoder : ResourceTypeLink -> Json.Encode.Value
resourceTypeLinkEncoder a =
    case a of
        ResourceTypeGroup ->
            Json.Encode.string "ResourceTypeGroup"

        ResourceTypeParent ->
            Json.Encode.string "ResourceTypeParent"


resourceTypeLinkDecoder : Json.Decode.Decoder ResourceTypeLink
resourceTypeLinkDecoder =
    Json.Decode.string
        |> Json.Decode.andThen
            (\a ->
                case a of
                    "ResourceTypeGroup" ->
                        Json.Decode.succeed ResourceTypeGroup

                    "ResourceTypeParent" ->
                        Json.Decode.succeed ResourceTypeParent

                    _ ->
                        Json.Decode.fail "No matching constructor"
            )


type EventTypeLink
    = EventTypeProvider
    | EventTypeReceiver
    | EventTypeInflow
    | EventTypeOutflow
    | EventTypeGroup
    | EventTypeParent


eventTypeLinkEncoder : EventTypeLink -> Json.Encode.Value
eventTypeLinkEncoder a =
    case a of
        EventTypeProvider ->
            Json.Encode.string "EventTypeProvider"

        EventTypeReceiver ->
            Json.Encode.string "EventTypeReceiver"

        EventTypeInflow ->
            Json.Encode.string "EventTypeInflow"

        EventTypeOutflow ->
            Json.Encode.string "EventTypeOutflow"

        EventTypeGroup ->
            Json.Encode.string "EventTypeGroup"

        EventTypeParent ->
            Json.Encode.string "EventTypeParent"


eventTypeLinkDecoder : Json.Decode.Decoder EventTypeLink
eventTypeLinkDecoder =
    Json.Decode.string
        |> Json.Decode.andThen
            (\a ->
                case a of
                    "EventTypeProvider" ->
                        Json.Decode.succeed EventTypeProvider

                    "EventTypeReceiver" ->
                        Json.Decode.succeed EventTypeReceiver

                    "EventTypeInflow" ->
                        Json.Decode.succeed EventTypeInflow

                    "EventTypeOutflow" ->
                        Json.Decode.succeed EventTypeOutflow

                    "EventTypeGroup" ->
                        Json.Decode.succeed EventTypeGroup

                    "EventTypeParent" ->
                        Json.Decode.succeed EventTypeParent

                    _ ->
                        Json.Decode.fail "No matching constructor"
            )


type AgentTypeLink
    = AgentTypeGroup
    | AgentTypeParent


agentTypeLinkEncoder : AgentTypeLink -> Json.Encode.Value
agentTypeLinkEncoder a =
    case a of
        AgentTypeGroup ->
            Json.Encode.string "AgentTypeGroup"

        AgentTypeParent ->
            Json.Encode.string "AgentTypeParent"


agentTypeLinkDecoder : Json.Decode.Decoder AgentTypeLink
agentTypeLinkDecoder =
    Json.Decode.string
        |> Json.Decode.andThen
            (\a ->
                case a of
                    "AgentTypeGroup" ->
                        Json.Decode.succeed AgentTypeGroup

                    "AgentTypeParent" ->
                        Json.Decode.succeed AgentTypeParent

                    _ ->
                        Json.Decode.fail "No matching constructor"
            )


type CommitmentTypeLink
    = CommitmentTypeProvider
    | CommitmentTypeReceiver
    | CommitmentTypeInflow
    | CommitmentTypeOutflow
    | CommitmentTypeGroup
    | CommitmentTypeParent


commitmentTypeLinkEncoder : CommitmentTypeLink -> Json.Encode.Value
commitmentTypeLinkEncoder a =
    case a of
        CommitmentTypeProvider ->
            Json.Encode.string "CommitmentTypeProvider"

        CommitmentTypeReceiver ->
            Json.Encode.string "CommitmentTypeReceiver"

        CommitmentTypeInflow ->
            Json.Encode.string "CommitmentTypeInflow"

        CommitmentTypeOutflow ->
            Json.Encode.string "CommitmentTypeOutflow"

        CommitmentTypeGroup ->
            Json.Encode.string "CommitmentTypeGroup"

        CommitmentTypeParent ->
            Json.Encode.string "CommitmentTypeParent"


commitmentTypeLinkDecoder : Json.Decode.Decoder CommitmentTypeLink
commitmentTypeLinkDecoder =
    Json.Decode.string
        |> Json.Decode.andThen
            (\a ->
                case a of
                    "CommitmentTypeProvider" ->
                        Json.Decode.succeed CommitmentTypeProvider

                    "CommitmentTypeReceiver" ->
                        Json.Decode.succeed CommitmentTypeReceiver

                    "CommitmentTypeInflow" ->
                        Json.Decode.succeed CommitmentTypeInflow

                    "CommitmentTypeOutflow" ->
                        Json.Decode.succeed CommitmentTypeOutflow

                    "CommitmentTypeGroup" ->
                        Json.Decode.succeed CommitmentTypeGroup

                    "CommitmentTypeParent" ->
                        Json.Decode.succeed CommitmentTypeParent

                    _ ->
                        Json.Decode.fail "No matching constructor"
            )


type ContractTypeLink
    = ContractTypeGroup
    | ContractTypeParent


contractTypeLinkEncoder : ContractTypeLink -> Json.Encode.Value
contractTypeLinkEncoder a =
    case a of
        ContractTypeGroup ->
            Json.Encode.string "ContractTypeGroup"

        ContractTypeParent ->
            Json.Encode.string "ContractTypeParent"


contractTypeLinkDecoder : Json.Decode.Decoder ContractTypeLink
contractTypeLinkDecoder =
    Json.Decode.string
        |> Json.Decode.andThen
            (\a ->
                case a of
                    "ContractTypeGroup" ->
                        Json.Decode.succeed ContractTypeGroup

                    "ContractTypeParent" ->
                        Json.Decode.succeed ContractTypeParent

                    _ ->
                        Json.Decode.fail "No matching constructor"
            )


type ProcessTypeLink
    = ProcessTypeGroup
    | ProcessTypeParent


processTypeLinkEncoder : ProcessTypeLink -> Json.Encode.Value
processTypeLinkEncoder a =
    case a of
        ProcessTypeGroup ->
            Json.Encode.string "ProcessTypeGroup"

        ProcessTypeParent ->
            Json.Encode.string "ProcessTypeParent"


processTypeLinkDecoder : Json.Decode.Decoder ProcessTypeLink
processTypeLinkDecoder =
    Json.Decode.string
        |> Json.Decode.andThen
            (\a ->
                case a of
                    "ProcessTypeGroup" ->
                        Json.Decode.succeed ProcessTypeGroup

                    "ProcessTypeParent" ->
                        Json.Decode.succeed ProcessTypeParent

                    _ ->
                        Json.Decode.fail "No matching constructor"
            )


type GroupTypeLink
    = GroupTypeGroup
    | GroupTypeParent


groupTypeLinkEncoder : GroupTypeLink -> Json.Encode.Value
groupTypeLinkEncoder a =
    case a of
        GroupTypeGroup ->
            Json.Encode.string "GroupTypeGroup"

        GroupTypeParent ->
            Json.Encode.string "GroupTypeParent"


groupTypeLinkDecoder : Json.Decode.Decoder GroupTypeLink
groupTypeLinkDecoder =
    Json.Decode.string
        |> Json.Decode.andThen
            (\a ->
                case a of
                    "GroupTypeGroup" ->
                        Json.Decode.succeed GroupTypeGroup

                    "GroupTypeParent" ->
                        Json.Decode.succeed GroupTypeParent

                    _ ->
                        Json.Decode.fail "No matching constructor"
            )
