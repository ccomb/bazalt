module Expression.DeepLink exposing (addTail, isComplete, terminate)

import Ontology.Expression.Deeplink exposing (DeepLink(..))
import Ontology.Expression.HardLink exposing (HardLink)
import Ontology.Scope exposing (Scope)


addTail : HardLink -> DeepLink -> DeepLink
addTail hl dl =
    case dl of
        Null ->
            Link hl dl

        Link hl2 dl2 ->
            Link hl2 (addTail hl dl2)

        EndPoint scope name ->
            Link hl (EndPoint scope name)


isComplete : DeepLink -> Bool
isComplete deeplink =
    case deeplink of
        Null ->
            False

        Link _ dl ->
            isComplete dl

        EndPoint _ _ ->
            True


terminate : Scope -> String -> DeepLink -> DeepLink
terminate scope name dl =
    case dl of
        Null ->
            EndPoint scope name

        Link hl dl2 ->
            Link hl (terminate scope name dl2)

        EndPoint _ _ ->
            EndPoint scope name
