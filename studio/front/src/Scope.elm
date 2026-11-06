module Scope exposing (anything, compare, empty, or, toString, toType)

import Ontology.Scope exposing (Scope(..))
import Ontology.Type exposing (Type)
import Prng.Uuid as Uuid
import Type


empty : Scope
empty =
    Empty


anything : Scope
anything =
    Anything


or : Scope -> Scope -> Scope
or s1 s2 =
    Or s1 s2


toString : Scope -> String
toString scope =
    -- for technical use (like compare)
    -- TODO remove to force use of Scope.View.toDisplay
    case scope of
        Empty ->
            "Nothing"

        Anything ->
            "Anything"

        IsItem t uuid ->
            Type.toString t ++ "(uuid=" ++ Uuid.toString uuid ++ ")"

        HasType t ->
            Type.toString t

        HasUserType t parentUuid ->
            Type.toString t ++ "(typeUuid=" ++ Uuid.toString parentUuid ++ ")"

        Identified _ ->
            "Identified"

        And s1 s2 ->
            "(" ++ toString s1 ++ ") And (" ++ toString s2 ++ ")"

        Or s1 s2 ->
            "(" ++ toString s1 ++ ") Or (" ++ toString s2 ++ ")"

        Not s ->
            "Not (" ++ toString s ++ ")"


compare : Scope -> String
compare =
    toString


toType : Scope -> Maybe Type
toType scope =
    case scope of
        Empty ->
            Nothing

        Anything ->
            -- TODO this is inconsistent. Try to remove this function
            Nothing

        IsItem t _ ->
            Just t

        HasType t ->
            Just t

        HasUserType t _ ->
            Just t

        Identified _ ->
            Nothing

        And _ _ ->
            -- TODO this is inconsistent. Try to remove this function
            Nothing

        Or _ _ ->
            -- TODO this is inconsistent. Try to remove this function
            Nothing

        Not _ ->
            -- TODO this is inconsistent. Try to remove this function
            Nothing
