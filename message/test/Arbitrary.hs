{-# OPTIONS_GHC -Wno-orphans #-}

-- | Random values of every message type, for property tests.
module Arbitrary () where

import Agent.Agent (Agent)
import AgentType.AgentType (AgentType)
import Commitment.Commitment (Commitment)
import CommitmentType.CommitmentType (CommitmentType)
import Configuration (Configuration)
import Configuration.Zone (Zone)
import Configuration.Zone.Fragment qualified as Zone
import Connection (Connection)
import Contract.Contract (Contract)
import ContractType.ContractType (ContractType)
import Data.Ratio ((%))
import Data.Text (Text)
import Data.Text qualified as T
import Data.Time.Calendar.Month (Month (..))
import Data.Time.Calendar.WeekDate (DayOfWeek (..))
import Data.Time.Clock.POSIX (POSIXTime)
import Data.UUID (UUID)
import Data.UUID qualified as UUID
import Event.Event (Event)
import EventType.EventType (EventType)
import Expression (Expression (..))
import Expression.Binary qualified as B
import Expression.Deeplink (DeepLink (..))
import Expression.HardLink
import Expression.Observable (Observable)
import Expression.Unary qualified as U
import Expression.ValueSelection (ValueSelection)
import Flow (Flow)
import Generic.Random (genericArbitraryU)
import Group.Group (Group)
import Group.Link qualified as GroupLink
import GroupType.GroupType (GroupType)
import Ident.Fragment qualified as Ident
import Ident.Identification (Identification)
import Ident.Identifier (Identifier)
import Ident.IdentifierType (IdentifierType)
import Message (Message)
import MessageFlow (MessageFlow)
import Metadata (Metadata)
import Payload (Payload)
import Process.Process (Process)
import Process.Reconcile (Reconciliation)
import ProcessType.ProcessType (ProcessType)
import Resource.Resource (Resource)
import ResourceType.ResourceType (ResourceType)
import Scope (Scope (..))
import Service (Service)
import Test.QuickCheck
import Tree (TreeType)
import Type (Type)
import Value.Value (Value)
import Value.ValueType (ValueType)

-- Primitives, at the resolution of the domain.

instance Arbitrary UUID where
    arbitrary = UUID.fromWords <$> arbitrary <*> arbitrary <*> arbitrary <*> arbitrary

instance Arbitrary Text where
    arbitrary = T.pack <$> arbitrary
    shrink = fmap T.pack . shrink . T.unpack

-- | Instants to the millisecond, between 1970 and 2100.
instance {-# OVERLAPPING #-} Arbitrary POSIXTime where
    arbitrary = (/ 1000) . fromInteger <$> choose (0, 4102444800000)

-- | Rationals whose parts fit a JavaScript number exactly.
instance {-# OVERLAPPING #-} Arbitrary Rational where
    arbitrary = (%) <$> choose (-limit, limit) <*> choose (1, limit)
      where
        limit = 2 ^ (53 :: Int)

instance Arbitrary Month where
    arbitrary = MkMonth <$> choose (0, 9999 * 12 + 11)

instance Arbitrary DayOfWeek where
    arbitrary = elements [Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday]

-- Recursive types, whose depth shrinks with the size.

instance Arbitrary Scope where
    arbitrary = sized go
      where
        go 0 = oneof leaves
        go n = oneof $ leaves ++ [And <$> half <*> half, Or <$> half <*> half, Not <$> go (n - 1)]
          where
            half = go (n `div` 2)
        leaves =
            [ pure Empty
            , pure Anything
            , IsItem <$> arbitrary <*> arbitrary
            , HasUserType <$> arbitrary <*> arbitrary
            , HasType <$> arbitrary
            , Identified <$> arbitrary
            ]

instance Arbitrary Expression where
    arbitrary = sized go
      where
        go 0 = Leaf <$> arbitrary
        go n =
            oneof
                [ Leaf <$> scale (`div` 2) arbitrary
                , Unary <$> arbitrary <*> go (n - 1)
                , Binary <$> arbitrary <*> go (n `div` 2) <*> go (n `div` 2)
                ]

instance Arbitrary DeepLink where
    arbitrary = sized go
      where
        go 0 = oneof [pure Null, EndPoint <$> arbitrary <*> arbitrary]
        go n = oneof [pure Null, EndPoint <$> scale (`div` 2) arbitrary <*> arbitrary, Link <$> arbitrary <*> go (n - 1)]

-- Everything else, from its structure.

instance Arbitrary Agent where arbitrary = genericArbitraryU
instance Arbitrary AgentLink where arbitrary = genericArbitraryU
instance Arbitrary AgentType where arbitrary = genericArbitraryU
instance Arbitrary AgentTypeLink where arbitrary = genericArbitraryU
instance Arbitrary B.Operator where arbitrary = genericArbitraryU
instance Arbitrary Commitment where arbitrary = genericArbitraryU
instance Arbitrary CommitmentLink where arbitrary = genericArbitraryU
instance Arbitrary CommitmentType where arbitrary = genericArbitraryU
instance Arbitrary CommitmentTypeLink where arbitrary = genericArbitraryU
instance Arbitrary Configuration where arbitrary = genericArbitraryU
instance Arbitrary Connection where arbitrary = genericArbitraryU
instance Arbitrary Contract where arbitrary = genericArbitraryU
instance Arbitrary ContractLink where arbitrary = genericArbitraryU
instance Arbitrary ContractType where arbitrary = genericArbitraryU
instance Arbitrary ContractTypeLink where arbitrary = genericArbitraryU
instance Arbitrary Event where arbitrary = genericArbitraryU
instance Arbitrary EventLink where arbitrary = genericArbitraryU
instance Arbitrary EventType where arbitrary = genericArbitraryU
instance Arbitrary EventTypeLink where arbitrary = genericArbitraryU
instance Arbitrary Flow where arbitrary = genericArbitraryU
instance Arbitrary Group where arbitrary = genericArbitraryU
instance Arbitrary GroupLink where arbitrary = genericArbitraryU
instance Arbitrary GroupLink.Link where arbitrary = genericArbitraryU
instance Arbitrary GroupType where arbitrary = genericArbitraryU
instance Arbitrary GroupTypeLink where arbitrary = genericArbitraryU
instance Arbitrary HardLink where arbitrary = genericArbitraryU
instance Arbitrary Ident.Fragment where arbitrary = genericArbitraryU
instance Arbitrary Identification where arbitrary = genericArbitraryU
instance Arbitrary Identifier where arbitrary = genericArbitraryU
instance Arbitrary IdentifierType where arbitrary = genericArbitraryU
instance Arbitrary Message where arbitrary = genericArbitraryU
instance Arbitrary MessageFlow where arbitrary = genericArbitraryU
instance Arbitrary Metadata where arbitrary = genericArbitraryU
instance Arbitrary Observable where arbitrary = genericArbitraryU
instance Arbitrary Payload where arbitrary = genericArbitraryU
instance Arbitrary Process where arbitrary = genericArbitraryU
instance Arbitrary ProcessLink where arbitrary = genericArbitraryU
instance Arbitrary ProcessType where arbitrary = genericArbitraryU
instance Arbitrary ProcessTypeLink where arbitrary = genericArbitraryU
instance Arbitrary Reconciliation where arbitrary = genericArbitraryU
instance Arbitrary Resource where arbitrary = genericArbitraryU
instance Arbitrary ResourceLink where arbitrary = genericArbitraryU
instance Arbitrary ResourceType where arbitrary = genericArbitraryU
instance Arbitrary ResourceTypeLink where arbitrary = genericArbitraryU
instance Arbitrary Service where arbitrary = genericArbitraryU
instance Arbitrary TreeType where arbitrary = genericArbitraryU
instance Arbitrary Type where arbitrary = genericArbitraryU
instance Arbitrary U.Operator where arbitrary = genericArbitraryU
instance Arbitrary Value where arbitrary = genericArbitraryU
instance Arbitrary ValueSelection where arbitrary = genericArbitraryU
instance Arbitrary ValueType where arbitrary = genericArbitraryU
instance Arbitrary Zone where arbitrary = genericArbitraryU
instance Arbitrary Zone.Fragment where arbitrary = genericArbitraryU
