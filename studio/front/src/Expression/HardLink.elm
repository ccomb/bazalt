module Expression.HardLink exposing (chooseFromScope, toScope, toString)

import Ontology.Expression.HardLink exposing (AgentLink(..), AgentTypeLink(..), CommitmentLink(..), CommitmentTypeLink(..), ContractLink(..), ContractTypeLink(..), EventLink(..), EventTypeLink(..), GroupLink(..), GroupTypeLink(..), HardLink(..), ProcessLink(..), ProcessTypeLink(..), ResourceLink(..), ResourceTypeLink(..))
import Ontology.Hierarchy.Type as HType
import Ontology.Scope exposing (Scope(..))
import Ontology.Type as Type exposing (Type)
import Ontology.Typed.Type as TType


toString : HardLink -> String
toString hardlink =
    case hardlink of
        ResourceLink ResourceGroup ->
            "Resource Group"

        ResourceLink ResourceType ->
            "Resource Type"

        EventLink EventProvider ->
            "Event Provider"

        EventLink EventReceiver ->
            "Event Receiver"

        EventLink EventInflow ->
            "Event Incoming Resource"

        EventLink EventOutflow ->
            "Event Outgoing Resource"

        EventLink EventGroup ->
            "Event Group"

        EventLink EventType ->
            "Event Type"

        AgentLink AgentGroup ->
            "Agent Group"

        AgentLink AgentType ->
            "Agent Type"

        CommitmentLink CommitmentProvider ->
            "Commitment Provider"

        CommitmentLink CommitmentReceiver ->
            "Commitment Receiver"

        CommitmentLink CommitmentInflow ->
            "Commitment Incoming Resource"

        CommitmentLink CommitmentOutflow ->
            "Commitment Outgoing Resource"

        CommitmentLink CommitmentGroup ->
            "Commitment Group"

        CommitmentLink CommitmentType ->
            "Commitment Type"

        ContractLink ContractGroup ->
            "Contract Group"

        ContractLink ContractType ->
            "Contract Type"

        ProcessLink ProcessGroup ->
            "Process Group"

        ProcessLink ProcessType ->
            "Process Type"

        GroupLink GroupGroup ->
            "Group Group"

        GroupLink GroupType ->
            "Group Type"

        GroupLink ParentGroup ->
            "Parent Group"

        ResourceTypeLink ResourceTypeGroup ->
            "ResourceType Group"

        ResourceTypeLink ResourceTypeParent ->
            "ResourceType Parent"

        EventTypeLink EventTypeProvider ->
            "Event Type Provider"

        EventTypeLink EventTypeReceiver ->
            "Event Type Receiver"

        EventTypeLink EventTypeInflow ->
            "Event Type Incoming Resource"

        EventTypeLink EventTypeOutflow ->
            "Event Type Outgoing Resource"

        EventTypeLink EventTypeGroup ->
            "Event Type Group"

        EventTypeLink EventTypeParent ->
            "Event Type Parent Type"

        AgentTypeLink AgentTypeGroup ->
            "Agent Type Group"

        AgentTypeLink AgentTypeParent ->
            "Agent Type Type"

        CommitmentTypeLink CommitmentTypeProvider ->
            "Commitment Type Provider Agent"

        CommitmentTypeLink CommitmentTypeReceiver ->
            "Commitment Type Receiver Agent"

        CommitmentTypeLink CommitmentTypeInflow ->
            "Commitment Type Incoming Resource"

        CommitmentTypeLink CommitmentTypeOutflow ->
            "Commitment Type Outgoing Resource"

        CommitmentTypeLink CommitmentTypeGroup ->
            "Commitment Type Group"

        CommitmentTypeLink CommitmentTypeParent ->
            "Commitment Type Parent Type"

        ContractTypeLink ContractTypeGroup ->
            "Contract Type Group"

        ContractTypeLink ContractTypeParent ->
            "Contract Type Type"

        ProcessTypeLink ProcessTypeGroup ->
            "Process Type Group"

        ProcessTypeLink ProcessTypeParent ->
            "Process Type Parent Type"

        GroupTypeLink GroupTypeGroup ->
            "Group Type Group"

        GroupTypeLink GroupTypeParent ->
            "Group Type Parent Type"


allRL : List HardLink
allRL =
    [ ResourceLink ResourceGroup
    , ResourceLink ResourceType
    ]


allEL : List HardLink
allEL =
    [ EventLink EventProvider, EventLink EventReceiver, EventLink EventInflow, EventLink EventOutflow, EventLink EventGroup, EventLink EventType ]


allAL : List HardLink
allAL =
    [ AgentLink AgentGroup, AgentLink AgentType ]


allCmL : List HardLink
allCmL =
    [ CommitmentLink CommitmentProvider
    , CommitmentLink CommitmentReceiver
    , CommitmentLink CommitmentInflow
    , CommitmentLink CommitmentOutflow
    , CommitmentLink CommitmentGroup
    , CommitmentLink CommitmentType
    ]


allCnL : List HardLink
allCnL =
    [ ContractLink ContractGroup, ContractLink ContractType ]


allPL : List HardLink
allPL =
    [ ProcessLink ProcessGroup, ProcessLink ProcessType ]


allGL : List HardLink
allGL =
    [ GroupLink ParentGroup, GroupLink GroupGroup, GroupLink GroupType ]


allRTL : List HardLink
allRTL =
    [ ResourceTypeLink ResourceTypeGroup, ResourceTypeLink ResourceTypeParent ]


allETL : List HardLink
allETL =
    [ EventTypeLink EventTypeProvider, EventTypeLink EventTypeReceiver, EventTypeLink EventTypeInflow, EventTypeLink EventTypeOutflow, EventTypeLink EventTypeGroup, EventTypeLink EventTypeParent ]


allATL : List HardLink
allATL =
    [ AgentTypeLink AgentTypeGroup, AgentTypeLink AgentTypeParent ]


allCmTL : List HardLink
allCmTL =
    [ CommitmentTypeLink CommitmentTypeProvider, CommitmentTypeLink CommitmentTypeReceiver, CommitmentTypeLink CommitmentTypeInflow, CommitmentTypeLink CommitmentTypeOutflow, CommitmentTypeLink CommitmentTypeGroup, CommitmentTypeLink CommitmentTypeParent ]


allCnTL : List HardLink
allCnTL =
    [ ContractTypeLink ContractTypeGroup, ContractTypeLink ContractTypeParent ]


allPTL : List HardLink
allPTL =
    [ ProcessTypeLink ProcessTypeGroup, ProcessTypeLink ProcessTypeParent ]


allGTL : List HardLink
allGTL =
    [ GroupTypeLink GroupTypeGroup, GroupTypeLink GroupTypeParent ]


toScope : HardLink -> Scope
toScope hardlink =
    case hardlink of
        ResourceLink y ->
            rlToScope y

        EventLink y ->
            elToScope y

        AgentLink y ->
            alToScope y

        CommitmentLink y ->
            cmlToScope y

        ContractLink y ->
            cnlToScope y

        ProcessLink y ->
            plToScope y

        GroupLink y ->
            glToScope y

        ResourceTypeLink y ->
            rtlToScope y

        EventTypeLink y ->
            etlToScope y

        AgentTypeLink y ->
            atlToScope y

        CommitmentTypeLink y ->
            cmtlToScope y

        ContractTypeLink y ->
            cntlToScope y

        ProcessTypeLink y ->
            ptlToScope y

        GroupTypeLink y ->
            gtlToScope y


rlToScope : ResourceLink -> Scope
rlToScope hardlink =
    case hardlink of
        ResourceGroup ->
            HasType (Type.TType TType.Group)

        ResourceType ->
            HasType (Type.HType HType.ResourceType)


elToScope : EventLink -> Scope
elToScope hardlink =
    case hardlink of
        EventProvider ->
            HasType (Type.TType TType.Agent)

        EventReceiver ->
            HasType (Type.TType TType.Agent)

        EventInflow ->
            HasType (Type.TType TType.Resource)

        EventOutflow ->
            HasType (Type.TType TType.Resource)

        EventGroup ->
            HasType (Type.TType TType.Group)

        EventType ->
            HasType (Type.HType HType.EventType)


alToScope : AgentLink -> Scope
alToScope hardlink =
    case hardlink of
        AgentGroup ->
            HasType (Type.TType TType.Group)

        AgentType ->
            HasType (Type.HType HType.AgentType)


cmlToScope : CommitmentLink -> Scope
cmlToScope hardlink =
    case hardlink of
        CommitmentProvider ->
            HasType (Type.TType TType.Agent)

        CommitmentReceiver ->
            HasType (Type.TType TType.Agent)

        CommitmentInflow ->
            HasType (Type.TType TType.Resource)

        CommitmentOutflow ->
            HasType (Type.TType TType.Resource)

        CommitmentGroup ->
            HasType (Type.TType TType.Group)

        CommitmentType ->
            HasType (Type.HType HType.CommitmentType)


cnlToScope : ContractLink -> Scope
cnlToScope hardlink =
    case hardlink of
        ContractGroup ->
            HasType (Type.TType TType.Group)

        ContractType ->
            HasType (Type.HType HType.ContractType)


plToScope : ProcessLink -> Scope
plToScope hardlink =
    case hardlink of
        ProcessGroup ->
            HasType (Type.TType TType.Group)

        ProcessType ->
            HasType (Type.HType HType.ProcessType)


glToScope : GroupLink -> Scope
glToScope hardlink =
    case hardlink of
        ParentGroup ->
            HasType (Type.TType TType.Group)

        GroupGroup ->
            HasType (Type.TType TType.Group)

        GroupType ->
            HasType (Type.HType HType.GroupType)


rtlToScope : ResourceTypeLink -> Scope
rtlToScope hardlink =
    case hardlink of
        ResourceTypeGroup ->
            HasType (Type.TType TType.Group)

        ResourceTypeParent ->
            HasType (Type.HType HType.ResourceType)


etlToScope : EventTypeLink -> Scope
etlToScope hardlink =
    case hardlink of
        EventTypeProvider ->
            HasType (Type.TType TType.Agent)

        EventTypeReceiver ->
            HasType (Type.TType TType.Agent)

        EventTypeInflow ->
            -- TODO an inflow can also defined by be a RT
            HasType (Type.TType TType.Resource)

        EventTypeOutflow ->
            HasType (Type.TType TType.Resource)

        EventTypeGroup ->
            HasType (Type.TType TType.Group)

        EventTypeParent ->
            HasType (Type.HType HType.EventType)


atlToScope : AgentTypeLink -> Scope
atlToScope hardlink =
    case hardlink of
        AgentTypeGroup ->
            HasType (Type.TType TType.Group)

        AgentTypeParent ->
            HasType (Type.HType HType.AgentType)


cmtlToScope : CommitmentTypeLink -> Scope
cmtlToScope hardlink =
    case hardlink of
        CommitmentTypeProvider ->
            HasType (Type.TType TType.Agent)

        CommitmentTypeReceiver ->
            HasType (Type.TType TType.Agent)

        CommitmentTypeInflow ->
            HasType (Type.TType TType.Resource)

        CommitmentTypeOutflow ->
            HasType (Type.TType TType.Resource)

        CommitmentTypeGroup ->
            HasType (Type.TType TType.Group)

        CommitmentTypeParent ->
            HasType (Type.HType HType.CommitmentType)


cntlToScope : ContractTypeLink -> Scope
cntlToScope hardlink =
    case hardlink of
        ContractTypeGroup ->
            HasType (Type.TType TType.Group)

        ContractTypeParent ->
            HasType (Type.HType HType.ContractType)


ptlToScope : ProcessTypeLink -> Scope
ptlToScope hardlink =
    case hardlink of
        ProcessTypeGroup ->
            HasType (Type.TType TType.Group)

        ProcessTypeParent ->
            HasType (Type.HType HType.ProcessType)


gtlToScope : GroupTypeLink -> Scope
gtlToScope hardlink =
    case hardlink of
        GroupTypeGroup ->
            HasType (Type.TType TType.Group)

        GroupTypeParent ->
            HasType (Type.HType HType.GroupType)


chooseFromType : Type -> List HardLink
chooseFromType t =
    case t of
        Type.TType TType.Resource ->
            allRL

        Type.TType TType.Event ->
            allEL

        Type.TType TType.Agent ->
            allAL

        Type.TType TType.Commitment ->
            allCmL

        Type.TType TType.Contract ->
            allCnL

        Type.TType TType.Process ->
            allPL

        Type.TType TType.Group ->
            allGL

        Type.HType HType.ResourceType ->
            allRTL

        Type.HType HType.EventType ->
            allETL

        Type.HType HType.AgentType ->
            allATL

        Type.HType HType.CommitmentType ->
            allCmTL

        Type.HType HType.ContractType ->
            allCnTL

        Type.HType HType.ProcessType ->
            allPTL

        Type.HType HType.GroupType ->
            allGTL


chooseFromScope : Scope -> List HardLink
chooseFromScope scope =
    case scope of
        HasType t ->
            chooseFromType t

        HasUserType t _ ->
            chooseFromType t

        _ ->
            []
