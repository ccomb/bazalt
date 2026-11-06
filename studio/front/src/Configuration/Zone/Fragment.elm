module Configuration.Zone.Fragment exposing (toDesc, toString)

import Ontology.Configuration.Zone.Fragment exposing (Fragment(..))
import Scope


toString : Fragment -> String
toString fragment =
    case fragment of
        IdentifierName identifier ->
            identifier.name

        GroupIdentifierName groupidentifier ->
            groupidentifier.name

        Parent ->
            "Parent"

        Fixed _ ->
            "Fixed"

        Quantity ->
            "Quantity"

        Flow ->
            "Flow"

        Provider ->
            "Provider"

        Receiver ->
            "Receiver"

        EventList _ ->
            "EventList"


toDesc : Fragment -> String
toDesc fragment =
    case fragment of
        IdentifierName _ ->
            "Identifier"

        GroupIdentifierName groupidentifier ->
            "Identifier of a " ++ Scope.toString groupidentifier.scope

        Parent ->
            "Display the zone configuration of the Parent"

        Fixed _ ->
            "Always display a predefined string"

        Quantity ->
            "Display the quantity of the event"

        Flow ->
            "Display the Resource or ResourceType of the Event or Commitment"

        Provider ->
            "Display the provider of the Event or Commitment"

        Receiver ->
            "Display the receiver of the Event or Commitment"

        EventList _ ->
            "Display the list of partial Events, separated by configurable separators."
