module Typed.Typed exposing (isAscendantOf)

import Dict exposing (Dict)
import Hierarchy.Hierarchic as H
import Ontology.Type exposing (Type)
import Prng.Uuid exposing (Uuid)



--TODO : turn this into a non parametric type, and turn all types into an extension of Typed (same for Hierarchic)


isAscendantOf : Uuid -> Dict String ( Uuid, Type, Maybe Uuid ) -> Uuid -> Bool
isAscendantOf =
    H.isAscendantOf
