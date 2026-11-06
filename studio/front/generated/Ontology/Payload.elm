module Ontology.Payload exposing
    ( Payload(..)
    , payloadDecoder
    , payloadEncoder
    )

import Json.Decode
import Json.Decode.Pipeline
import Json.Encode
import Ontology.Agent.Agent
import Ontology.AgentType.AgentType
import Ontology.Commitment.Commitment
import Ontology.CommitmentType.CommitmentType
import Ontology.Configuration
import Ontology.Connection
import Ontology.Contract.Contract
import Ontology.ContractType.ContractType
import Ontology.Event.Event
import Ontology.EventType.EventType
import Ontology.Group.Group
import Ontology.Group.Link
import Ontology.GroupType.GroupType
import Ontology.Ident.Identifier
import Ontology.Ident.IdentifierType
import Ontology.Process.Process
import Ontology.Process.Reconcile
import Ontology.ProcessType.ProcessType
import Ontology.Resource.Resource
import Ontology.ResourceType.ResourceType
import Ontology.Value.Value
import Ontology.Value.ValueType
import Prng.Uuid


type Payload
    = InitiatedConnection Ontology.Connection.Connection
    | AddedResourceType Ontology.ResourceType.ResourceType.ResourceType
    | RemovedResourceType Prng.Uuid.Uuid
    | AddedEventType Ontology.EventType.EventType.EventType
    | RemovedEventType Prng.Uuid.Uuid
    | AddedAgentType Ontology.AgentType.AgentType.AgentType
    | RemovedAgentType Prng.Uuid.Uuid
    | AddedCommitmentType Ontology.CommitmentType.CommitmentType.CommitmentType
    | RemovedCommitmentType Prng.Uuid.Uuid
    | AddedContractType Ontology.ContractType.ContractType.ContractType
    | RemovedContractType Prng.Uuid.Uuid
    | AddedProcessType Ontology.ProcessType.ProcessType.ProcessType
    | RemovedProcessType Prng.Uuid.Uuid
    | AddedResource Ontology.Resource.Resource.Resource
    | RemovedResource Prng.Uuid.Uuid
    | AddedEvent Ontology.Event.Event.Event
    | RemovedEvent Prng.Uuid.Uuid
    | AddedAgent Ontology.Agent.Agent.Agent
    | RemovedAgent Prng.Uuid.Uuid
    | AddedCommitment Ontology.Commitment.Commitment.Commitment
    | RemovedCommitment Prng.Uuid.Uuid
    | AddedContract Ontology.Contract.Contract.Contract
    | RemovedContract Prng.Uuid.Uuid
    | AddedProcess Ontology.Process.Process.Process
    | RemovedProcess Prng.Uuid.Uuid
    | AddedIdentifierType Ontology.Ident.IdentifierType.IdentifierType
    | ChangedIdentifierType
        { old : Ontology.Ident.IdentifierType.IdentifierType
        , new : Ontology.Ident.IdentifierType.IdentifierType
        }
    | RemovedIdentifierType Ontology.Ident.IdentifierType.IdentifierType
    | AddedIdentifier Ontology.Ident.Identifier.Identifier
    | AddedValueType Ontology.Value.ValueType.ValueType
    | ChangedValueType Ontology.Value.ValueType.ValueType Ontology.Value.ValueType.ValueType
    | RemovedValueType Ontology.Value.ValueType.ValueType
    | AddedValue Ontology.Value.Value.Value
    | Configured Ontology.Configuration.Configuration
    | Unconfigured Ontology.Configuration.Configuration
    | AddedGroupType Ontology.GroupType.GroupType.GroupType
    | RemovedGroupType Prng.Uuid.Uuid
    | DefinedGroup Ontology.Group.Group.Group
    | RemovedGroup Prng.Uuid.Uuid
    | Grouped Ontology.Group.Link.Link
    | Ungrouped Ontology.Group.Link.Link
    | Reconciled Ontology.Process.Reconcile.Reconciliation
    | Unreconciled Ontology.Process.Reconcile.Reconciliation


payloadEncoder : Payload -> Json.Encode.Value
payloadEncoder a =
    case a of
        InitiatedConnection b ->
            Json.Encode.object
                [ ( "what", Json.Encode.string "InitiatedConnection" )
                , ( "load", Ontology.Connection.connectionEncoder b )
                ]

        AddedResourceType b ->
            Json.Encode.object
                [ ( "what", Json.Encode.string "AddedResourceType" )
                , ( "load", Ontology.ResourceType.ResourceType.resourceTypeEncoder b )
                ]

        RemovedResourceType b ->
            Json.Encode.object
                [ ( "what", Json.Encode.string "RemovedResourceType" )
                , ( "load", Prng.Uuid.encode b )
                ]

        AddedEventType b ->
            Json.Encode.object
                [ ( "what", Json.Encode.string "AddedEventType" )
                , ( "load", Ontology.EventType.EventType.eventTypeEncoder b )
                ]

        RemovedEventType b ->
            Json.Encode.object
                [ ( "what", Json.Encode.string "RemovedEventType" )
                , ( "load", Prng.Uuid.encode b )
                ]

        AddedAgentType b ->
            Json.Encode.object
                [ ( "what", Json.Encode.string "AddedAgentType" )
                , ( "load", Ontology.AgentType.AgentType.agentTypeEncoder b )
                ]

        RemovedAgentType b ->
            Json.Encode.object
                [ ( "what", Json.Encode.string "RemovedAgentType" )
                , ( "load", Prng.Uuid.encode b )
                ]

        AddedCommitmentType b ->
            Json.Encode.object
                [ ( "what", Json.Encode.string "AddedCommitmentType" )
                , ( "load", Ontology.CommitmentType.CommitmentType.commitmentTypeEncoder b )
                ]

        RemovedCommitmentType b ->
            Json.Encode.object
                [ ( "what", Json.Encode.string "RemovedCommitmentType" )
                , ( "load", Prng.Uuid.encode b )
                ]

        AddedContractType b ->
            Json.Encode.object
                [ ( "what", Json.Encode.string "AddedContractType" )
                , ( "load", Ontology.ContractType.ContractType.contractTypeEncoder b )
                ]

        RemovedContractType b ->
            Json.Encode.object
                [ ( "what", Json.Encode.string "RemovedContractType" )
                , ( "load", Prng.Uuid.encode b )
                ]

        AddedProcessType b ->
            Json.Encode.object
                [ ( "what", Json.Encode.string "AddedProcessType" )
                , ( "load", Ontology.ProcessType.ProcessType.processTypeEncoder b )
                ]

        RemovedProcessType b ->
            Json.Encode.object
                [ ( "what", Json.Encode.string "RemovedProcessType" )
                , ( "load", Prng.Uuid.encode b )
                ]

        AddedResource b ->
            Json.Encode.object
                [ ( "what", Json.Encode.string "AddedResource" )
                , ( "load", Ontology.Resource.Resource.resourceEncoder b )
                ]

        RemovedResource b ->
            Json.Encode.object
                [ ( "what", Json.Encode.string "RemovedResource" )
                , ( "load", Prng.Uuid.encode b )
                ]

        AddedEvent b ->
            Json.Encode.object
                [ ( "what", Json.Encode.string "AddedEvent" )
                , ( "load", Ontology.Event.Event.eventEncoder b )
                ]

        RemovedEvent b ->
            Json.Encode.object
                [ ( "what", Json.Encode.string "RemovedEvent" )
                , ( "load", Prng.Uuid.encode b )
                ]

        AddedAgent b ->
            Json.Encode.object
                [ ( "what", Json.Encode.string "AddedAgent" )
                , ( "load", Ontology.Agent.Agent.agentEncoder b )
                ]

        RemovedAgent b ->
            Json.Encode.object
                [ ( "what", Json.Encode.string "RemovedAgent" )
                , ( "load", Prng.Uuid.encode b )
                ]

        AddedCommitment b ->
            Json.Encode.object
                [ ( "what", Json.Encode.string "AddedCommitment" )
                , ( "load", Ontology.Commitment.Commitment.commitmentEncoder b )
                ]

        RemovedCommitment b ->
            Json.Encode.object
                [ ( "what", Json.Encode.string "RemovedCommitment" )
                , ( "load", Prng.Uuid.encode b )
                ]

        AddedContract b ->
            Json.Encode.object
                [ ( "what", Json.Encode.string "AddedContract" )
                , ( "load", Ontology.Contract.Contract.contractEncoder b )
                ]

        RemovedContract b ->
            Json.Encode.object
                [ ( "what", Json.Encode.string "RemovedContract" )
                , ( "load", Prng.Uuid.encode b )
                ]

        AddedProcess b ->
            Json.Encode.object
                [ ( "what", Json.Encode.string "AddedProcess" )
                , ( "load", Ontology.Process.Process.processEncoder b )
                ]

        RemovedProcess b ->
            Json.Encode.object
                [ ( "what", Json.Encode.string "RemovedProcess" )
                , ( "load", Prng.Uuid.encode b )
                ]

        AddedIdentifierType b ->
            Json.Encode.object
                [ ( "what", Json.Encode.string "AddedIdentifierType" )
                , ( "load", Ontology.Ident.IdentifierType.identifierTypeEncoder b )
                ]

        ChangedIdentifierType b ->
            Json.Encode.object
                [ ( "what", Json.Encode.string "ChangedIdentifierType" )
                , ( "old", Ontology.Ident.IdentifierType.identifierTypeEncoder b.old )
                , ( "new", Ontology.Ident.IdentifierType.identifierTypeEncoder b.new )
                ]

        RemovedIdentifierType b ->
            Json.Encode.object
                [ ( "what", Json.Encode.string "RemovedIdentifierType" )
                , ( "load", Ontology.Ident.IdentifierType.identifierTypeEncoder b )
                ]

        AddedIdentifier b ->
            Json.Encode.object
                [ ( "what", Json.Encode.string "AddedIdentifier" )
                , ( "load", Ontology.Ident.Identifier.identifierEncoder b )
                ]

        AddedValueType b ->
            Json.Encode.object
                [ ( "what", Json.Encode.string "AddedValueType" )
                , ( "load", Ontology.Value.ValueType.valueTypeEncoder b )
                ]

        ChangedValueType b c ->
            Json.Encode.object
                [ ( "what", Json.Encode.string "ChangedValueType" )
                , ( "load"
                  , Json.Encode.list identity
                        [ Ontology.Value.ValueType.valueTypeEncoder b
                        , Ontology.Value.ValueType.valueTypeEncoder c
                        ]
                  )
                ]

        RemovedValueType b ->
            Json.Encode.object
                [ ( "what", Json.Encode.string "RemovedValueType" )
                , ( "load", Ontology.Value.ValueType.valueTypeEncoder b )
                ]

        AddedValue b ->
            Json.Encode.object
                [ ( "what", Json.Encode.string "AddedValue" )
                , ( "load", Ontology.Value.Value.valueEncoder b )
                ]

        Configured b ->
            Json.Encode.object
                [ ( "what", Json.Encode.string "Configured" )
                , ( "load", Ontology.Configuration.configurationEncoder b )
                ]

        Unconfigured b ->
            Json.Encode.object
                [ ( "what", Json.Encode.string "Unconfigured" )
                , ( "load", Ontology.Configuration.configurationEncoder b )
                ]

        AddedGroupType b ->
            Json.Encode.object
                [ ( "what", Json.Encode.string "AddedGroupType" )
                , ( "load", Ontology.GroupType.GroupType.groupTypeEncoder b )
                ]

        RemovedGroupType b ->
            Json.Encode.object
                [ ( "what", Json.Encode.string "RemovedGroupType" )
                , ( "load", Prng.Uuid.encode b )
                ]

        DefinedGroup b ->
            Json.Encode.object
                [ ( "what", Json.Encode.string "DefinedGroup" )
                , ( "load", Ontology.Group.Group.groupEncoder b )
                ]

        RemovedGroup b ->
            Json.Encode.object
                [ ( "what", Json.Encode.string "RemovedGroup" )
                , ( "load", Prng.Uuid.encode b )
                ]

        Grouped b ->
            Json.Encode.object
                [ ( "what", Json.Encode.string "Grouped" )
                , ( "load", Ontology.Group.Link.linkEncoder b )
                ]

        Ungrouped b ->
            Json.Encode.object
                [ ( "what", Json.Encode.string "Ungrouped" )
                , ( "load", Ontology.Group.Link.linkEncoder b )
                ]

        Reconciled b ->
            Json.Encode.object
                [ ( "what", Json.Encode.string "Reconciled" )
                , ( "load", Ontology.Process.Reconcile.reconciliationEncoder b )
                ]

        Unreconciled b ->
            Json.Encode.object
                [ ( "what", Json.Encode.string "Unreconciled" )
                , ( "load", Ontology.Process.Reconcile.reconciliationEncoder b )
                ]


payloadDecoder : Json.Decode.Decoder Payload
payloadDecoder =
    Json.Decode.field "what" Json.Decode.string
        |> Json.Decode.andThen
            (\a ->
                case a of
                    "InitiatedConnection" ->
                        Json.Decode.succeed InitiatedConnection
                            |> Json.Decode.Pipeline.required "load" Ontology.Connection.connectionDecoder

                    "AddedResourceType" ->
                        Json.Decode.succeed AddedResourceType
                            |> Json.Decode.Pipeline.required "load" Ontology.ResourceType.ResourceType.resourceTypeDecoder

                    "RemovedResourceType" ->
                        Json.Decode.succeed RemovedResourceType
                            |> Json.Decode.Pipeline.required "load" Prng.Uuid.decoder

                    "AddedEventType" ->
                        Json.Decode.succeed AddedEventType
                            |> Json.Decode.Pipeline.required "load" Ontology.EventType.EventType.eventTypeDecoder

                    "RemovedEventType" ->
                        Json.Decode.succeed RemovedEventType
                            |> Json.Decode.Pipeline.required "load" Prng.Uuid.decoder

                    "AddedAgentType" ->
                        Json.Decode.succeed AddedAgentType
                            |> Json.Decode.Pipeline.required "load" Ontology.AgentType.AgentType.agentTypeDecoder

                    "RemovedAgentType" ->
                        Json.Decode.succeed RemovedAgentType
                            |> Json.Decode.Pipeline.required "load" Prng.Uuid.decoder

                    "AddedCommitmentType" ->
                        Json.Decode.succeed AddedCommitmentType
                            |> Json.Decode.Pipeline.required "load" Ontology.CommitmentType.CommitmentType.commitmentTypeDecoder

                    "RemovedCommitmentType" ->
                        Json.Decode.succeed RemovedCommitmentType
                            |> Json.Decode.Pipeline.required "load" Prng.Uuid.decoder

                    "AddedContractType" ->
                        Json.Decode.succeed AddedContractType
                            |> Json.Decode.Pipeline.required "load" Ontology.ContractType.ContractType.contractTypeDecoder

                    "RemovedContractType" ->
                        Json.Decode.succeed RemovedContractType
                            |> Json.Decode.Pipeline.required "load" Prng.Uuid.decoder

                    "AddedProcessType" ->
                        Json.Decode.succeed AddedProcessType
                            |> Json.Decode.Pipeline.required "load" Ontology.ProcessType.ProcessType.processTypeDecoder

                    "RemovedProcessType" ->
                        Json.Decode.succeed RemovedProcessType
                            |> Json.Decode.Pipeline.required "load" Prng.Uuid.decoder

                    "AddedResource" ->
                        Json.Decode.succeed AddedResource
                            |> Json.Decode.Pipeline.required "load" Ontology.Resource.Resource.resourceDecoder

                    "RemovedResource" ->
                        Json.Decode.succeed RemovedResource
                            |> Json.Decode.Pipeline.required "load" Prng.Uuid.decoder

                    "AddedEvent" ->
                        Json.Decode.succeed AddedEvent
                            |> Json.Decode.Pipeline.required "load" Ontology.Event.Event.eventDecoder

                    "RemovedEvent" ->
                        Json.Decode.succeed RemovedEvent
                            |> Json.Decode.Pipeline.required "load" Prng.Uuid.decoder

                    "AddedAgent" ->
                        Json.Decode.succeed AddedAgent
                            |> Json.Decode.Pipeline.required "load" Ontology.Agent.Agent.agentDecoder

                    "RemovedAgent" ->
                        Json.Decode.succeed RemovedAgent
                            |> Json.Decode.Pipeline.required "load" Prng.Uuid.decoder

                    "AddedCommitment" ->
                        Json.Decode.succeed AddedCommitment
                            |> Json.Decode.Pipeline.required "load" Ontology.Commitment.Commitment.commitmentDecoder

                    "RemovedCommitment" ->
                        Json.Decode.succeed RemovedCommitment
                            |> Json.Decode.Pipeline.required "load" Prng.Uuid.decoder

                    "AddedContract" ->
                        Json.Decode.succeed AddedContract
                            |> Json.Decode.Pipeline.required "load" Ontology.Contract.Contract.contractDecoder

                    "RemovedContract" ->
                        Json.Decode.succeed RemovedContract
                            |> Json.Decode.Pipeline.required "load" Prng.Uuid.decoder

                    "AddedProcess" ->
                        Json.Decode.succeed AddedProcess
                            |> Json.Decode.Pipeline.required "load" Ontology.Process.Process.processDecoder

                    "RemovedProcess" ->
                        Json.Decode.succeed RemovedProcess
                            |> Json.Decode.Pipeline.required "load" Prng.Uuid.decoder

                    "AddedIdentifierType" ->
                        Json.Decode.succeed AddedIdentifierType
                            |> Json.Decode.Pipeline.required "load" Ontology.Ident.IdentifierType.identifierTypeDecoder

                    "ChangedIdentifierType" ->
                        Json.Decode.map ChangedIdentifierType
                            (Json.Decode.succeed
                                (\b c ->
                                    { old = b
                                    , new = c
                                    }
                                )
                                |> Json.Decode.Pipeline.required "old" Ontology.Ident.IdentifierType.identifierTypeDecoder
                                |> Json.Decode.Pipeline.required "new" Ontology.Ident.IdentifierType.identifierTypeDecoder
                            )

                    "RemovedIdentifierType" ->
                        Json.Decode.succeed RemovedIdentifierType
                            |> Json.Decode.Pipeline.required "load" Ontology.Ident.IdentifierType.identifierTypeDecoder

                    "AddedIdentifier" ->
                        Json.Decode.succeed AddedIdentifier
                            |> Json.Decode.Pipeline.required "load" Ontology.Ident.Identifier.identifierDecoder

                    "AddedValueType" ->
                        Json.Decode.succeed AddedValueType
                            |> Json.Decode.Pipeline.required "load" Ontology.Value.ValueType.valueTypeDecoder

                    "ChangedValueType" ->
                        Json.Decode.field "load"
                            (Json.Decode.succeed ChangedValueType
                                |> Json.Decode.Pipeline.custom (Json.Decode.index 0 Ontology.Value.ValueType.valueTypeDecoder)
                                |> Json.Decode.Pipeline.custom (Json.Decode.index 1 Ontology.Value.ValueType.valueTypeDecoder)
                            )

                    "RemovedValueType" ->
                        Json.Decode.succeed RemovedValueType
                            |> Json.Decode.Pipeline.required "load" Ontology.Value.ValueType.valueTypeDecoder

                    "AddedValue" ->
                        Json.Decode.succeed AddedValue
                            |> Json.Decode.Pipeline.required "load" Ontology.Value.Value.valueDecoder

                    "Configured" ->
                        Json.Decode.succeed Configured
                            |> Json.Decode.Pipeline.required "load" Ontology.Configuration.configurationDecoder

                    "Unconfigured" ->
                        Json.Decode.succeed Unconfigured
                            |> Json.Decode.Pipeline.required "load" Ontology.Configuration.configurationDecoder

                    "AddedGroupType" ->
                        Json.Decode.succeed AddedGroupType
                            |> Json.Decode.Pipeline.required "load" Ontology.GroupType.GroupType.groupTypeDecoder

                    "RemovedGroupType" ->
                        Json.Decode.succeed RemovedGroupType
                            |> Json.Decode.Pipeline.required "load" Prng.Uuid.decoder

                    "DefinedGroup" ->
                        Json.Decode.succeed DefinedGroup
                            |> Json.Decode.Pipeline.required "load" Ontology.Group.Group.groupDecoder

                    "RemovedGroup" ->
                        Json.Decode.succeed RemovedGroup
                            |> Json.Decode.Pipeline.required "load" Prng.Uuid.decoder

                    "Grouped" ->
                        Json.Decode.succeed Grouped
                            |> Json.Decode.Pipeline.required "load" Ontology.Group.Link.linkDecoder

                    "Ungrouped" ->
                        Json.Decode.succeed Ungrouped
                            |> Json.Decode.Pipeline.required "load" Ontology.Group.Link.linkDecoder

                    "Reconciled" ->
                        Json.Decode.succeed Reconciled
                            |> Json.Decode.Pipeline.required "load" Ontology.Process.Reconcile.reconciliationDecoder

                    "Unreconciled" ->
                        Json.Decode.succeed Unreconciled
                            |> Json.Decode.Pipeline.required "load" Ontology.Process.Reconcile.reconciliationDecoder

                    _ ->
                        Json.Decode.fail "No matching constructor"
            )
