module Metadata exposing (compare)

import MessageFlow
import Prng.Uuid as Uuid
import Service


compare : Metadata -> String
compare m =
    MessageFlow.toString m.flow ++ ":" ++ Uuid.toString m.uuid ++ ":" ++ String.join "→" (List.map Service.toString m.from)
