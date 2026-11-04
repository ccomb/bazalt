module MessageFlow exposing (toString)

import Ontology.MessageFlow exposing (MessageFlow(..))


toString : MessageFlow -> String
toString m =
    case m of
        Requested ->
            "Requested"

        Processed ->
            "Processed"

        Error reason ->
            "Error: " ++ reason
