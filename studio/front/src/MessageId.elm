module MessageId exposing (MessageId, compare)

import MessageFlow
import Ontology.MessageFlow exposing (MessageFlow)
import Prng.Uuid as Uuid exposing (Uuid)


type alias MessageId =
    ( Uuid, MessageFlow )


compare : MessageId -> String
compare ( uuid, flow ) =
    Uuid.toString uuid ++ ":" ++ MessageFlow.toString flow
