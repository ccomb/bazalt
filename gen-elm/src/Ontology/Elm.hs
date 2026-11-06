{-# LANGUAGE AllowAmbiguousTypes #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DerivingVia #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE UndecidableInstances #-}
{-# OPTIONS_GHC -Wno-orphans #-}

{- | How each type of the ontology is written in Elm. The codecs follow the
same aeson options as the Haskell instances, read from the Json module, so
the two sides cannot disagree on the wire format.

Every type of @message@ must be listed in 'definitions'; a type missing
from it but used by another one makes the generated Elm fail to compile.
-}
module Ontology.Elm (definitions, Tagged (..)) where

import Agent.Agent qualified
import AgentType.AgentType qualified
import Calendar qualified
import Commitment.Commitment qualified
import CommitmentType.CommitmentType qualified
import Configuration qualified
import Configuration.Zone qualified
import Configuration.Zone.Fragment qualified
import Connection qualified
import Contract.Contract qualified
import ContractType.ContractType qualified
import Data.Aeson qualified as Aeson
import Data.Char (toLower)
import Data.Proxy (Proxy (..))
import Data.Ratio (Ratio)
import Data.Set (Set)
import Data.Text qualified as T
import Data.Time.Clock.POSIX (POSIXTime)
import Data.UUID (UUID)
import Event.Event qualified
import EventType.EventType qualified
import Expression qualified
import Expression.Binary qualified
import Expression.Deeplink qualified
import Expression.HardLink qualified
import Expression.Observable qualified
import Expression.Unary qualified
import Expression.ValueSelection qualified
import Flow qualified
import Generics.SOP qualified as SOP
import Group.Group qualified
import Group.Link qualified
import GroupType.GroupType qualified
import Hierarchy.Type qualified
import Ident.Fragment qualified
import Ident.Identification qualified
import Ident.Identifier qualified
import Ident.IdentifierType qualified
import Json (payloadOptions, taggedOptions)
import Language.Elm.Definition (Definition)
import Language.Elm.Expression qualified as Elm.Expression
import Language.Elm.Name qualified as Name
import Language.Elm.Simplification (simplifyDefinition)
import Language.Elm.Type qualified as Elm.Type
import Language.Haskell.To.Elm
import Message qualified
import MessageFlow qualified
import Metadata qualified
import Payload qualified
import Process.Process qualified
import Process.Reconcile qualified
import ProcessType.ProcessType qualified
import Resource.Resource qualified
import ResourceType.ResourceType qualified
import Scope qualified
import Service qualified
import Tree qualified
import Type qualified
import Typed.Type qualified
import Value.Value qualified
import Value.ValueType qualified

-- | Every Elm definition to generate.
definitions :: [Definition]
definitions =
    simplifyDefinition
        <$> concat
            [ jsonDefinitions @Agent.Agent.Agent
            , jsonDefinitions @AgentType.AgentType.AgentType
            , jsonDefinitions @Calendar.Month
            , jsonDefinitions @Calendar.Weekday
            , jsonDefinitions @Commitment.Commitment.Commitment
            , jsonDefinitions @CommitmentType.CommitmentType.CommitmentType
            , jsonDefinitions @Configuration.Configuration
            , jsonDefinitions @Configuration.Zone.Zone
            , jsonDefinitions @Configuration.Zone.Fragment.Fragment
            , jsonDefinitions @Connection.Connection
            , jsonDefinitions @Contract.Contract.Contract
            , jsonDefinitions @ContractType.ContractType.ContractType
            , jsonDefinitions @Event.Event.Event
            , jsonDefinitions @EventType.EventType.EventType
            , jsonDefinitions @Expression.Expression
            , jsonDefinitions @Expression.Binary.Operator
            , jsonDefinitions @Expression.Deeplink.DeepLink
            , jsonDefinitions @Expression.HardLink.HardLink
            , jsonDefinitions @Expression.HardLink.ResourceLink
            , jsonDefinitions @Expression.HardLink.EventLink
            , jsonDefinitions @Expression.HardLink.AgentLink
            , jsonDefinitions @Expression.HardLink.CommitmentLink
            , jsonDefinitions @Expression.HardLink.ContractLink
            , jsonDefinitions @Expression.HardLink.ProcessLink
            , jsonDefinitions @Expression.HardLink.GroupLink
            , jsonDefinitions @Expression.HardLink.ResourceTypeLink
            , jsonDefinitions @Expression.HardLink.EventTypeLink
            , jsonDefinitions @Expression.HardLink.AgentTypeLink
            , jsonDefinitions @Expression.HardLink.CommitmentTypeLink
            , jsonDefinitions @Expression.HardLink.ContractTypeLink
            , jsonDefinitions @Expression.HardLink.ProcessTypeLink
            , jsonDefinitions @Expression.HardLink.GroupTypeLink
            , jsonDefinitions @Expression.Observable.Observable
            , jsonDefinitions @Expression.Unary.Operator
            , jsonDefinitions @Expression.ValueSelection.ValueSelection
            , jsonDefinitions @Flow.Flow
            , jsonDefinitions @Group.Group.Group
            , jsonDefinitions @Group.Link.Link
            , jsonDefinitions @GroupType.GroupType.GroupType
            , jsonDefinitions @Ident.Fragment.Fragment
            , jsonDefinitions @Ident.Identification.Identification
            , jsonDefinitions @Ident.Identifier.Identifier
            , jsonDefinitions @Ident.IdentifierType.IdentifierType
            , jsonDefinitions @Message.Message
            , jsonDefinitions @MessageFlow.MessageFlow
            , jsonDefinitions @Metadata.Metadata
            , jsonDefinitions @Payload.Payload
            , jsonDefinitions @Process.Process.Process
            , jsonDefinitions @Process.Reconcile.Reconciliation
            , jsonDefinitions @ProcessType.ProcessType.ProcessType
            , jsonDefinitions @Resource.Resource.Resource
            , jsonDefinitions @ResourceType.ResourceType.ResourceType
            , jsonDefinitions @Scope.Scope
            , jsonDefinitions @Service.Service
            , jsonDefinitions @Tree.TreeType
            , jsonDefinitions @Type.Type
            , jsonDefinitions @Typed.Type.Type
            , jsonDefinitions @Hierarchy.Type.Type
            , jsonDefinitions @Value.Value.Value
            , jsonDefinitions @Value.ValueType.ValueType
            ]

-- Primitives, whose Elm codecs are written by hand in Ontology.Prim.

instance HasElmType UUID where
    elmType = "Prng.Uuid.Uuid"

instance HasElmDecoder Aeson.Value UUID where
    elmDecoder = "Prng.Uuid.decoder"

instance HasElmEncoder Aeson.Value UUID where
    elmEncoder = "Prng.Uuid.encode"

instance HasElmType POSIXTime where
    elmType = "Time.Posix"

instance HasElmDecoder Aeson.Value POSIXTime where
    elmDecoder = "Ontology.Prim.posixDecoder"

instance HasElmEncoder Aeson.Value POSIXTime where
    elmEncoder = "Ontology.Prim.posixEncoder"

instance HasElmType (Ratio Integer) where
    elmType = "Ontology.Prim.Rational"

instance HasElmDecoder Aeson.Value (Ratio Integer) where
    elmDecoder = "Ontology.Prim.rationalDecoder"

instance HasElmEncoder Aeson.Value (Ratio Integer) where
    elmEncoder = "Ontology.Prim.rationalEncoder"

{- | A set travels as a JSON list. Elm sets need comparable elements, which
most of ours are not, so the Elm side holds a list.
-}
instance (HasElmType a) => HasElmType (Set a) where
    elmType = Elm.Type.App "List.List" (elmType @a)

instance (HasElmDecoder Aeson.Value a) => HasElmDecoder Aeson.Value (Set a) where
    elmDecoder = Elm.Expression.App "Json.Decode.list" (elmDecoder @Aeson.Value @a)

instance (HasElmEncoder Aeson.Value a) => HasElmEncoder Aeson.Value (Set a) where
    elmEncoder = Elm.Expression.App "Json.Encode.list" (elmEncoder @Aeson.Value @a)

-- Types of the ontology.

{- | Derives the Elm type and codecs of @a@ with 'taggedOptions'. The Elm
module mirrors the Haskell one under @Ontology@: @Event.Event.Event@
becomes @Ontology.Event.Event.Event@, with @eventDecoder@ and
@eventEncoder@ beside it.
-}
newtype Tagged a = Tagged a

instance (SOP.HasDatatypeInfo a, SOP.All2 HasElmType (SOP.Code a)) => HasElmType (Tagged a) where
    elmDefinition = Just $ deriveElmTypeDefinition @a defaultOptions (elmName @a "")

instance (HasElmType a, SOP.HasDatatypeInfo a, SOP.All2 HasElmType (SOP.Code a), SOP.All2 (HasElmDecoder Aeson.Value) (SOP.Code a)) => HasElmDecoder Aeson.Value (Tagged a) where
    elmDecoderDefinition = Just $ deriveElmJSONDecoder @a defaultOptions taggedOptions (elmName @a "Decoder")

instance (HasElmType a, SOP.HasDatatypeInfo a, SOP.All2 HasElmType (SOP.Code a), SOP.All2 (HasElmEncoder Aeson.Value) (SOP.Code a)) => HasElmEncoder Aeson.Value (Tagged a) where
    elmEncoderDefinition = Just $ deriveElmJSONEncoder @a defaultOptions taggedOptions (elmName @a "Encoder")

-- | The Elm name of the type @a@, or of its codec when given a suffix.
elmName :: forall a. (SOP.HasDatatypeInfo a) => T.Text -> Name.Qualified
elmName suffix = Name.Qualified ("Ontology" : T.splitOn "." (T.pack (SOP.moduleName info))) name
  where
    info = SOP.datatypeInfo (Proxy @a)
    typeName = T.pack (SOP.datatypeName info)
    name
        | T.null suffix = typeName
        | otherwise = T.cons (toLower (T.head typeName)) (T.tail typeName) <> suffix

deriving anyclass instance SOP.Generic Agent.Agent.Agent
deriving anyclass instance SOP.HasDatatypeInfo Agent.Agent.Agent
deriving anyclass instance SOP.Generic AgentType.AgentType.AgentType
deriving anyclass instance SOP.HasDatatypeInfo AgentType.AgentType.AgentType
deriving anyclass instance SOP.Generic Calendar.Month
deriving anyclass instance SOP.HasDatatypeInfo Calendar.Month
deriving anyclass instance SOP.Generic Calendar.Weekday
deriving anyclass instance SOP.HasDatatypeInfo Calendar.Weekday
deriving anyclass instance SOP.Generic Commitment.Commitment.Commitment
deriving anyclass instance SOP.HasDatatypeInfo Commitment.Commitment.Commitment
deriving anyclass instance SOP.Generic CommitmentType.CommitmentType.CommitmentType
deriving anyclass instance SOP.HasDatatypeInfo CommitmentType.CommitmentType.CommitmentType
deriving anyclass instance SOP.Generic Configuration.Configuration
deriving anyclass instance SOP.HasDatatypeInfo Configuration.Configuration
deriving anyclass instance SOP.Generic Configuration.Zone.Zone
deriving anyclass instance SOP.HasDatatypeInfo Configuration.Zone.Zone
deriving anyclass instance SOP.Generic Configuration.Zone.Fragment.Fragment
deriving anyclass instance SOP.HasDatatypeInfo Configuration.Zone.Fragment.Fragment
deriving anyclass instance SOP.Generic Connection.Connection
deriving anyclass instance SOP.HasDatatypeInfo Connection.Connection
deriving anyclass instance SOP.Generic Contract.Contract.Contract
deriving anyclass instance SOP.HasDatatypeInfo Contract.Contract.Contract
deriving anyclass instance SOP.Generic ContractType.ContractType.ContractType
deriving anyclass instance SOP.HasDatatypeInfo ContractType.ContractType.ContractType
deriving anyclass instance SOP.Generic Event.Event.Event
deriving anyclass instance SOP.HasDatatypeInfo Event.Event.Event
deriving anyclass instance SOP.Generic EventType.EventType.EventType
deriving anyclass instance SOP.HasDatatypeInfo EventType.EventType.EventType
deriving anyclass instance SOP.Generic Expression.Expression
deriving anyclass instance SOP.HasDatatypeInfo Expression.Expression
deriving anyclass instance SOP.Generic Expression.Binary.Operator
deriving anyclass instance SOP.HasDatatypeInfo Expression.Binary.Operator
deriving anyclass instance SOP.Generic Expression.Deeplink.DeepLink
deriving anyclass instance SOP.HasDatatypeInfo Expression.Deeplink.DeepLink
deriving anyclass instance SOP.Generic Expression.HardLink.HardLink
deriving anyclass instance SOP.HasDatatypeInfo Expression.HardLink.HardLink
deriving anyclass instance SOP.Generic Expression.HardLink.ResourceLink
deriving anyclass instance SOP.HasDatatypeInfo Expression.HardLink.ResourceLink
deriving anyclass instance SOP.Generic Expression.HardLink.EventLink
deriving anyclass instance SOP.HasDatatypeInfo Expression.HardLink.EventLink
deriving anyclass instance SOP.Generic Expression.HardLink.AgentLink
deriving anyclass instance SOP.HasDatatypeInfo Expression.HardLink.AgentLink
deriving anyclass instance SOP.Generic Expression.HardLink.CommitmentLink
deriving anyclass instance SOP.HasDatatypeInfo Expression.HardLink.CommitmentLink
deriving anyclass instance SOP.Generic Expression.HardLink.ContractLink
deriving anyclass instance SOP.HasDatatypeInfo Expression.HardLink.ContractLink
deriving anyclass instance SOP.Generic Expression.HardLink.ProcessLink
deriving anyclass instance SOP.HasDatatypeInfo Expression.HardLink.ProcessLink
deriving anyclass instance SOP.Generic Expression.HardLink.GroupLink
deriving anyclass instance SOP.HasDatatypeInfo Expression.HardLink.GroupLink
deriving anyclass instance SOP.Generic Expression.HardLink.ResourceTypeLink
deriving anyclass instance SOP.HasDatatypeInfo Expression.HardLink.ResourceTypeLink
deriving anyclass instance SOP.Generic Expression.HardLink.EventTypeLink
deriving anyclass instance SOP.HasDatatypeInfo Expression.HardLink.EventTypeLink
deriving anyclass instance SOP.Generic Expression.HardLink.AgentTypeLink
deriving anyclass instance SOP.HasDatatypeInfo Expression.HardLink.AgentTypeLink
deriving anyclass instance SOP.Generic Expression.HardLink.CommitmentTypeLink
deriving anyclass instance SOP.HasDatatypeInfo Expression.HardLink.CommitmentTypeLink
deriving anyclass instance SOP.Generic Expression.HardLink.ContractTypeLink
deriving anyclass instance SOP.HasDatatypeInfo Expression.HardLink.ContractTypeLink
deriving anyclass instance SOP.Generic Expression.HardLink.ProcessTypeLink
deriving anyclass instance SOP.HasDatatypeInfo Expression.HardLink.ProcessTypeLink
deriving anyclass instance SOP.Generic Expression.HardLink.GroupTypeLink
deriving anyclass instance SOP.HasDatatypeInfo Expression.HardLink.GroupTypeLink
deriving anyclass instance SOP.Generic Expression.Observable.Observable
deriving anyclass instance SOP.HasDatatypeInfo Expression.Observable.Observable
deriving anyclass instance SOP.Generic Expression.Unary.Operator
deriving anyclass instance SOP.HasDatatypeInfo Expression.Unary.Operator
deriving anyclass instance SOP.Generic Expression.ValueSelection.ValueSelection
deriving anyclass instance SOP.HasDatatypeInfo Expression.ValueSelection.ValueSelection
deriving anyclass instance SOP.Generic Flow.Flow
deriving anyclass instance SOP.HasDatatypeInfo Flow.Flow
deriving anyclass instance SOP.Generic Group.Group.Group
deriving anyclass instance SOP.HasDatatypeInfo Group.Group.Group
deriving anyclass instance SOP.Generic Group.Link.Link
deriving anyclass instance SOP.HasDatatypeInfo Group.Link.Link
deriving anyclass instance SOP.Generic GroupType.GroupType.GroupType
deriving anyclass instance SOP.HasDatatypeInfo GroupType.GroupType.GroupType
deriving anyclass instance SOP.Generic Ident.Fragment.Fragment
deriving anyclass instance SOP.HasDatatypeInfo Ident.Fragment.Fragment
deriving anyclass instance SOP.Generic Ident.Identification.Identification
deriving anyclass instance SOP.HasDatatypeInfo Ident.Identification.Identification
deriving anyclass instance SOP.Generic Ident.Identifier.Identifier
deriving anyclass instance SOP.HasDatatypeInfo Ident.Identifier.Identifier
deriving anyclass instance SOP.Generic Ident.IdentifierType.IdentifierType
deriving anyclass instance SOP.HasDatatypeInfo Ident.IdentifierType.IdentifierType
deriving anyclass instance SOP.Generic Message.Message
deriving anyclass instance SOP.HasDatatypeInfo Message.Message
deriving anyclass instance SOP.Generic MessageFlow.MessageFlow
deriving anyclass instance SOP.HasDatatypeInfo MessageFlow.MessageFlow
deriving anyclass instance SOP.Generic Metadata.Metadata
deriving anyclass instance SOP.HasDatatypeInfo Metadata.Metadata
deriving anyclass instance SOP.Generic Payload.Payload
deriving anyclass instance SOP.HasDatatypeInfo Payload.Payload
deriving anyclass instance SOP.Generic Process.Process.Process
deriving anyclass instance SOP.HasDatatypeInfo Process.Process.Process
deriving anyclass instance SOP.Generic Process.Reconcile.Reconciliation
deriving anyclass instance SOP.HasDatatypeInfo Process.Reconcile.Reconciliation
deriving anyclass instance SOP.Generic ProcessType.ProcessType.ProcessType
deriving anyclass instance SOP.HasDatatypeInfo ProcessType.ProcessType.ProcessType
deriving anyclass instance SOP.Generic Resource.Resource.Resource
deriving anyclass instance SOP.HasDatatypeInfo Resource.Resource.Resource
deriving anyclass instance SOP.Generic ResourceType.ResourceType.ResourceType
deriving anyclass instance SOP.HasDatatypeInfo ResourceType.ResourceType.ResourceType
deriving anyclass instance SOP.Generic Scope.Scope
deriving anyclass instance SOP.HasDatatypeInfo Scope.Scope
deriving anyclass instance SOP.Generic Service.Service
deriving anyclass instance SOP.HasDatatypeInfo Service.Service
deriving anyclass instance SOP.Generic Tree.TreeType
deriving anyclass instance SOP.HasDatatypeInfo Tree.TreeType
deriving anyclass instance SOP.Generic Type.Type
deriving anyclass instance SOP.HasDatatypeInfo Type.Type
deriving anyclass instance SOP.Generic Typed.Type.Type
deriving anyclass instance SOP.HasDatatypeInfo Typed.Type.Type
deriving anyclass instance SOP.Generic Hierarchy.Type.Type
deriving anyclass instance SOP.HasDatatypeInfo Hierarchy.Type.Type
deriving anyclass instance SOP.Generic Value.Value.Value
deriving anyclass instance SOP.HasDatatypeInfo Value.Value.Value
deriving anyclass instance SOP.Generic Value.ValueType.ValueType
deriving anyclass instance SOP.HasDatatypeInfo Value.ValueType.ValueType

deriving via Tagged Agent.Agent.Agent instance HasElmType Agent.Agent.Agent
deriving via Tagged Agent.Agent.Agent instance HasElmDecoder Aeson.Value Agent.Agent.Agent
deriving via Tagged Agent.Agent.Agent instance HasElmEncoder Aeson.Value Agent.Agent.Agent
deriving via Tagged AgentType.AgentType.AgentType instance HasElmType AgentType.AgentType.AgentType
deriving via Tagged AgentType.AgentType.AgentType instance HasElmDecoder Aeson.Value AgentType.AgentType.AgentType
deriving via Tagged AgentType.AgentType.AgentType instance HasElmEncoder Aeson.Value AgentType.AgentType.AgentType
deriving via Tagged Calendar.Month instance HasElmType Calendar.Month
deriving via Tagged Calendar.Month instance HasElmDecoder Aeson.Value Calendar.Month
deriving via Tagged Calendar.Month instance HasElmEncoder Aeson.Value Calendar.Month
deriving via Tagged Calendar.Weekday instance HasElmType Calendar.Weekday
deriving via Tagged Calendar.Weekday instance HasElmDecoder Aeson.Value Calendar.Weekday
deriving via Tagged Calendar.Weekday instance HasElmEncoder Aeson.Value Calendar.Weekday
deriving via Tagged Commitment.Commitment.Commitment instance HasElmType Commitment.Commitment.Commitment
deriving via Tagged Commitment.Commitment.Commitment instance HasElmDecoder Aeson.Value Commitment.Commitment.Commitment
deriving via Tagged Commitment.Commitment.Commitment instance HasElmEncoder Aeson.Value Commitment.Commitment.Commitment
deriving via Tagged CommitmentType.CommitmentType.CommitmentType instance HasElmType CommitmentType.CommitmentType.CommitmentType
deriving via Tagged CommitmentType.CommitmentType.CommitmentType instance HasElmDecoder Aeson.Value CommitmentType.CommitmentType.CommitmentType
deriving via Tagged CommitmentType.CommitmentType.CommitmentType instance HasElmEncoder Aeson.Value CommitmentType.CommitmentType.CommitmentType
deriving via Tagged Configuration.Configuration instance HasElmType Configuration.Configuration
deriving via Tagged Configuration.Configuration instance HasElmDecoder Aeson.Value Configuration.Configuration
deriving via Tagged Configuration.Configuration instance HasElmEncoder Aeson.Value Configuration.Configuration
deriving via Tagged Configuration.Zone.Zone instance HasElmType Configuration.Zone.Zone
deriving via Tagged Configuration.Zone.Zone instance HasElmDecoder Aeson.Value Configuration.Zone.Zone
deriving via Tagged Configuration.Zone.Zone instance HasElmEncoder Aeson.Value Configuration.Zone.Zone
deriving via Tagged Configuration.Zone.Fragment.Fragment instance HasElmType Configuration.Zone.Fragment.Fragment
deriving via Tagged Configuration.Zone.Fragment.Fragment instance HasElmDecoder Aeson.Value Configuration.Zone.Fragment.Fragment
deriving via Tagged Configuration.Zone.Fragment.Fragment instance HasElmEncoder Aeson.Value Configuration.Zone.Fragment.Fragment
deriving via Tagged Connection.Connection instance HasElmType Connection.Connection
deriving via Tagged Connection.Connection instance HasElmDecoder Aeson.Value Connection.Connection
deriving via Tagged Connection.Connection instance HasElmEncoder Aeson.Value Connection.Connection
deriving via Tagged Contract.Contract.Contract instance HasElmType Contract.Contract.Contract
deriving via Tagged Contract.Contract.Contract instance HasElmDecoder Aeson.Value Contract.Contract.Contract
deriving via Tagged Contract.Contract.Contract instance HasElmEncoder Aeson.Value Contract.Contract.Contract
deriving via Tagged ContractType.ContractType.ContractType instance HasElmType ContractType.ContractType.ContractType
deriving via Tagged ContractType.ContractType.ContractType instance HasElmDecoder Aeson.Value ContractType.ContractType.ContractType
deriving via Tagged ContractType.ContractType.ContractType instance HasElmEncoder Aeson.Value ContractType.ContractType.ContractType
deriving via Tagged Event.Event.Event instance HasElmType Event.Event.Event
deriving via Tagged Event.Event.Event instance HasElmDecoder Aeson.Value Event.Event.Event
deriving via Tagged Event.Event.Event instance HasElmEncoder Aeson.Value Event.Event.Event
deriving via Tagged EventType.EventType.EventType instance HasElmType EventType.EventType.EventType
deriving via Tagged EventType.EventType.EventType instance HasElmDecoder Aeson.Value EventType.EventType.EventType
deriving via Tagged EventType.EventType.EventType instance HasElmEncoder Aeson.Value EventType.EventType.EventType
deriving via Tagged Expression.Expression instance HasElmType Expression.Expression
deriving via Tagged Expression.Expression instance HasElmDecoder Aeson.Value Expression.Expression
deriving via Tagged Expression.Expression instance HasElmEncoder Aeson.Value Expression.Expression
deriving via Tagged Expression.Binary.Operator instance HasElmType Expression.Binary.Operator
deriving via Tagged Expression.Binary.Operator instance HasElmDecoder Aeson.Value Expression.Binary.Operator
deriving via Tagged Expression.Binary.Operator instance HasElmEncoder Aeson.Value Expression.Binary.Operator
deriving via Tagged Expression.Deeplink.DeepLink instance HasElmType Expression.Deeplink.DeepLink
deriving via Tagged Expression.Deeplink.DeepLink instance HasElmDecoder Aeson.Value Expression.Deeplink.DeepLink
deriving via Tagged Expression.Deeplink.DeepLink instance HasElmEncoder Aeson.Value Expression.Deeplink.DeepLink
deriving via Tagged Expression.HardLink.HardLink instance HasElmType Expression.HardLink.HardLink
deriving via Tagged Expression.HardLink.HardLink instance HasElmDecoder Aeson.Value Expression.HardLink.HardLink
deriving via Tagged Expression.HardLink.HardLink instance HasElmEncoder Aeson.Value Expression.HardLink.HardLink
deriving via Tagged Expression.HardLink.ResourceLink instance HasElmType Expression.HardLink.ResourceLink
deriving via Tagged Expression.HardLink.ResourceLink instance HasElmDecoder Aeson.Value Expression.HardLink.ResourceLink
deriving via Tagged Expression.HardLink.ResourceLink instance HasElmEncoder Aeson.Value Expression.HardLink.ResourceLink
deriving via Tagged Expression.HardLink.EventLink instance HasElmType Expression.HardLink.EventLink
deriving via Tagged Expression.HardLink.EventLink instance HasElmDecoder Aeson.Value Expression.HardLink.EventLink
deriving via Tagged Expression.HardLink.EventLink instance HasElmEncoder Aeson.Value Expression.HardLink.EventLink
deriving via Tagged Expression.HardLink.AgentLink instance HasElmType Expression.HardLink.AgentLink
deriving via Tagged Expression.HardLink.AgentLink instance HasElmDecoder Aeson.Value Expression.HardLink.AgentLink
deriving via Tagged Expression.HardLink.AgentLink instance HasElmEncoder Aeson.Value Expression.HardLink.AgentLink
deriving via Tagged Expression.HardLink.CommitmentLink instance HasElmType Expression.HardLink.CommitmentLink
deriving via Tagged Expression.HardLink.CommitmentLink instance HasElmDecoder Aeson.Value Expression.HardLink.CommitmentLink
deriving via Tagged Expression.HardLink.CommitmentLink instance HasElmEncoder Aeson.Value Expression.HardLink.CommitmentLink
deriving via Tagged Expression.HardLink.ContractLink instance HasElmType Expression.HardLink.ContractLink
deriving via Tagged Expression.HardLink.ContractLink instance HasElmDecoder Aeson.Value Expression.HardLink.ContractLink
deriving via Tagged Expression.HardLink.ContractLink instance HasElmEncoder Aeson.Value Expression.HardLink.ContractLink
deriving via Tagged Expression.HardLink.ProcessLink instance HasElmType Expression.HardLink.ProcessLink
deriving via Tagged Expression.HardLink.ProcessLink instance HasElmDecoder Aeson.Value Expression.HardLink.ProcessLink
deriving via Tagged Expression.HardLink.ProcessLink instance HasElmEncoder Aeson.Value Expression.HardLink.ProcessLink
deriving via Tagged Expression.HardLink.GroupLink instance HasElmType Expression.HardLink.GroupLink
deriving via Tagged Expression.HardLink.GroupLink instance HasElmDecoder Aeson.Value Expression.HardLink.GroupLink
deriving via Tagged Expression.HardLink.GroupLink instance HasElmEncoder Aeson.Value Expression.HardLink.GroupLink
deriving via Tagged Expression.HardLink.ResourceTypeLink instance HasElmType Expression.HardLink.ResourceTypeLink
deriving via Tagged Expression.HardLink.ResourceTypeLink instance HasElmDecoder Aeson.Value Expression.HardLink.ResourceTypeLink
deriving via Tagged Expression.HardLink.ResourceTypeLink instance HasElmEncoder Aeson.Value Expression.HardLink.ResourceTypeLink
deriving via Tagged Expression.HardLink.EventTypeLink instance HasElmType Expression.HardLink.EventTypeLink
deriving via Tagged Expression.HardLink.EventTypeLink instance HasElmDecoder Aeson.Value Expression.HardLink.EventTypeLink
deriving via Tagged Expression.HardLink.EventTypeLink instance HasElmEncoder Aeson.Value Expression.HardLink.EventTypeLink
deriving via Tagged Expression.HardLink.AgentTypeLink instance HasElmType Expression.HardLink.AgentTypeLink
deriving via Tagged Expression.HardLink.AgentTypeLink instance HasElmDecoder Aeson.Value Expression.HardLink.AgentTypeLink
deriving via Tagged Expression.HardLink.AgentTypeLink instance HasElmEncoder Aeson.Value Expression.HardLink.AgentTypeLink
deriving via Tagged Expression.HardLink.CommitmentTypeLink instance HasElmType Expression.HardLink.CommitmentTypeLink
deriving via Tagged Expression.HardLink.CommitmentTypeLink instance HasElmDecoder Aeson.Value Expression.HardLink.CommitmentTypeLink
deriving via Tagged Expression.HardLink.CommitmentTypeLink instance HasElmEncoder Aeson.Value Expression.HardLink.CommitmentTypeLink
deriving via Tagged Expression.HardLink.ContractTypeLink instance HasElmType Expression.HardLink.ContractTypeLink
deriving via Tagged Expression.HardLink.ContractTypeLink instance HasElmDecoder Aeson.Value Expression.HardLink.ContractTypeLink
deriving via Tagged Expression.HardLink.ContractTypeLink instance HasElmEncoder Aeson.Value Expression.HardLink.ContractTypeLink
deriving via Tagged Expression.HardLink.ProcessTypeLink instance HasElmType Expression.HardLink.ProcessTypeLink
deriving via Tagged Expression.HardLink.ProcessTypeLink instance HasElmDecoder Aeson.Value Expression.HardLink.ProcessTypeLink
deriving via Tagged Expression.HardLink.ProcessTypeLink instance HasElmEncoder Aeson.Value Expression.HardLink.ProcessTypeLink
deriving via Tagged Expression.HardLink.GroupTypeLink instance HasElmType Expression.HardLink.GroupTypeLink
deriving via Tagged Expression.HardLink.GroupTypeLink instance HasElmDecoder Aeson.Value Expression.HardLink.GroupTypeLink
deriving via Tagged Expression.HardLink.GroupTypeLink instance HasElmEncoder Aeson.Value Expression.HardLink.GroupTypeLink
deriving via Tagged Expression.Observable.Observable instance HasElmType Expression.Observable.Observable
deriving via Tagged Expression.Observable.Observable instance HasElmDecoder Aeson.Value Expression.Observable.Observable
deriving via Tagged Expression.Observable.Observable instance HasElmEncoder Aeson.Value Expression.Observable.Observable
deriving via Tagged Expression.Unary.Operator instance HasElmType Expression.Unary.Operator
deriving via Tagged Expression.Unary.Operator instance HasElmDecoder Aeson.Value Expression.Unary.Operator
deriving via Tagged Expression.Unary.Operator instance HasElmEncoder Aeson.Value Expression.Unary.Operator
deriving via Tagged Expression.ValueSelection.ValueSelection instance HasElmType Expression.ValueSelection.ValueSelection
deriving via Tagged Expression.ValueSelection.ValueSelection instance HasElmDecoder Aeson.Value Expression.ValueSelection.ValueSelection
deriving via Tagged Expression.ValueSelection.ValueSelection instance HasElmEncoder Aeson.Value Expression.ValueSelection.ValueSelection
deriving via Tagged Flow.Flow instance HasElmType Flow.Flow
deriving via Tagged Flow.Flow instance HasElmDecoder Aeson.Value Flow.Flow
deriving via Tagged Flow.Flow instance HasElmEncoder Aeson.Value Flow.Flow
deriving via Tagged Group.Group.Group instance HasElmType Group.Group.Group
deriving via Tagged Group.Group.Group instance HasElmDecoder Aeson.Value Group.Group.Group
deriving via Tagged Group.Group.Group instance HasElmEncoder Aeson.Value Group.Group.Group
deriving via Tagged Group.Link.Link instance HasElmType Group.Link.Link
deriving via Tagged Group.Link.Link instance HasElmDecoder Aeson.Value Group.Link.Link
deriving via Tagged Group.Link.Link instance HasElmEncoder Aeson.Value Group.Link.Link
deriving via Tagged GroupType.GroupType.GroupType instance HasElmType GroupType.GroupType.GroupType
deriving via Tagged GroupType.GroupType.GroupType instance HasElmDecoder Aeson.Value GroupType.GroupType.GroupType
deriving via Tagged GroupType.GroupType.GroupType instance HasElmEncoder Aeson.Value GroupType.GroupType.GroupType
deriving via Tagged Ident.Fragment.Fragment instance HasElmType Ident.Fragment.Fragment
deriving via Tagged Ident.Fragment.Fragment instance HasElmDecoder Aeson.Value Ident.Fragment.Fragment
deriving via Tagged Ident.Fragment.Fragment instance HasElmEncoder Aeson.Value Ident.Fragment.Fragment
deriving via Tagged Ident.Identification.Identification instance HasElmType Ident.Identification.Identification
deriving via Tagged Ident.Identification.Identification instance HasElmDecoder Aeson.Value Ident.Identification.Identification
deriving via Tagged Ident.Identification.Identification instance HasElmEncoder Aeson.Value Ident.Identification.Identification
deriving via Tagged Ident.Identifier.Identifier instance HasElmType Ident.Identifier.Identifier
deriving via Tagged Ident.Identifier.Identifier instance HasElmDecoder Aeson.Value Ident.Identifier.Identifier
deriving via Tagged Ident.Identifier.Identifier instance HasElmEncoder Aeson.Value Ident.Identifier.Identifier
deriving via Tagged Ident.IdentifierType.IdentifierType instance HasElmType Ident.IdentifierType.IdentifierType
deriving via Tagged Ident.IdentifierType.IdentifierType instance HasElmDecoder Aeson.Value Ident.IdentifierType.IdentifierType
deriving via Tagged Ident.IdentifierType.IdentifierType instance HasElmEncoder Aeson.Value Ident.IdentifierType.IdentifierType
deriving via Tagged Message.Message instance HasElmType Message.Message
deriving via Tagged Message.Message instance HasElmDecoder Aeson.Value Message.Message
deriving via Tagged Message.Message instance HasElmEncoder Aeson.Value Message.Message
deriving via Tagged MessageFlow.MessageFlow instance HasElmType MessageFlow.MessageFlow
deriving via Tagged MessageFlow.MessageFlow instance HasElmDecoder Aeson.Value MessageFlow.MessageFlow
deriving via Tagged MessageFlow.MessageFlow instance HasElmEncoder Aeson.Value MessageFlow.MessageFlow
deriving via Tagged Metadata.Metadata instance HasElmType Metadata.Metadata
deriving via Tagged Metadata.Metadata instance HasElmDecoder Aeson.Value Metadata.Metadata
deriving via Tagged Metadata.Metadata instance HasElmEncoder Aeson.Value Metadata.Metadata
deriving via Tagged Process.Process.Process instance HasElmType Process.Process.Process
deriving via Tagged Process.Process.Process instance HasElmDecoder Aeson.Value Process.Process.Process
deriving via Tagged Process.Process.Process instance HasElmEncoder Aeson.Value Process.Process.Process
deriving via Tagged Process.Reconcile.Reconciliation instance HasElmType Process.Reconcile.Reconciliation
deriving via Tagged Process.Reconcile.Reconciliation instance HasElmDecoder Aeson.Value Process.Reconcile.Reconciliation
deriving via Tagged Process.Reconcile.Reconciliation instance HasElmEncoder Aeson.Value Process.Reconcile.Reconciliation
deriving via Tagged ProcessType.ProcessType.ProcessType instance HasElmType ProcessType.ProcessType.ProcessType
deriving via Tagged ProcessType.ProcessType.ProcessType instance HasElmDecoder Aeson.Value ProcessType.ProcessType.ProcessType
deriving via Tagged ProcessType.ProcessType.ProcessType instance HasElmEncoder Aeson.Value ProcessType.ProcessType.ProcessType
deriving via Tagged Resource.Resource.Resource instance HasElmType Resource.Resource.Resource
deriving via Tagged Resource.Resource.Resource instance HasElmDecoder Aeson.Value Resource.Resource.Resource
deriving via Tagged Resource.Resource.Resource instance HasElmEncoder Aeson.Value Resource.Resource.Resource
deriving via Tagged ResourceType.ResourceType.ResourceType instance HasElmType ResourceType.ResourceType.ResourceType
deriving via Tagged ResourceType.ResourceType.ResourceType instance HasElmDecoder Aeson.Value ResourceType.ResourceType.ResourceType
deriving via Tagged ResourceType.ResourceType.ResourceType instance HasElmEncoder Aeson.Value ResourceType.ResourceType.ResourceType
deriving via Tagged Scope.Scope instance HasElmType Scope.Scope
deriving via Tagged Scope.Scope instance HasElmDecoder Aeson.Value Scope.Scope
deriving via Tagged Scope.Scope instance HasElmEncoder Aeson.Value Scope.Scope
deriving via Tagged Service.Service instance HasElmType Service.Service
deriving via Tagged Service.Service instance HasElmDecoder Aeson.Value Service.Service
deriving via Tagged Service.Service instance HasElmEncoder Aeson.Value Service.Service
deriving via Tagged Tree.TreeType instance HasElmType Tree.TreeType
deriving via Tagged Tree.TreeType instance HasElmDecoder Aeson.Value Tree.TreeType
deriving via Tagged Tree.TreeType instance HasElmEncoder Aeson.Value Tree.TreeType
deriving via Tagged Type.Type instance HasElmType Type.Type
deriving via Tagged Type.Type instance HasElmDecoder Aeson.Value Type.Type
deriving via Tagged Type.Type instance HasElmEncoder Aeson.Value Type.Type
deriving via Tagged Typed.Type.Type instance HasElmType Typed.Type.Type
deriving via Tagged Typed.Type.Type instance HasElmDecoder Aeson.Value Typed.Type.Type
deriving via Tagged Typed.Type.Type instance HasElmEncoder Aeson.Value Typed.Type.Type
deriving via Tagged Hierarchy.Type.Type instance HasElmType Hierarchy.Type.Type
deriving via Tagged Hierarchy.Type.Type instance HasElmDecoder Aeson.Value Hierarchy.Type.Type
deriving via Tagged Hierarchy.Type.Type instance HasElmEncoder Aeson.Value Hierarchy.Type.Type
deriving via Tagged Value.Value.Value instance HasElmType Value.Value.Value
deriving via Tagged Value.Value.Value instance HasElmDecoder Aeson.Value Value.Value.Value
deriving via Tagged Value.Value.Value instance HasElmEncoder Aeson.Value Value.Value.Value
deriving via Tagged Value.ValueType.ValueType instance HasElmType Value.ValueType.ValueType
deriving via Tagged Value.ValueType.ValueType instance HasElmDecoder Aeson.Value Value.ValueType.ValueType
deriving via Tagged Value.ValueType.ValueType instance HasElmEncoder Aeson.Value Value.ValueType.ValueType

instance HasElmType Payload.Payload where
    elmDefinition = Just $ deriveElmTypeDefinition @Payload.Payload defaultOptions (elmName @Payload.Payload "")

instance HasElmDecoder Aeson.Value Payload.Payload where
    elmDecoderDefinition = Just $ deriveElmJSONDecoder @Payload.Payload defaultOptions payloadOptions (elmName @Payload.Payload "Decoder")

instance HasElmEncoder Aeson.Value Payload.Payload where
    elmEncoderDefinition = Just $ deriveElmJSONEncoder @Payload.Payload defaultOptions payloadOptions (elmName @Payload.Payload "Encoder")
