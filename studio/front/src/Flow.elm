module Flow exposing (userTypeOf, uuidOf)

import Ontology.Flow exposing (Flow(..))
import Ontology.Hierarchy.Type as HType
import Ontology.Type as Type exposing (Type)
import Ontology.Typed.Type as TType
import Prng.Uuid exposing (Uuid)


uuidOf : Flow -> Uuid
uuidOf flow =
    case flow of
        ResourceFlow r ->
            r.uuid

        ResourceTypeFlow rt ->
            rt.uuid


userTypeOf : Flow -> Type
userTypeOf flow =
    case flow of
        ResourceFlow _ ->
            Type.TType TType.Resource

        ResourceTypeFlow _ ->
            Type.HType HType.ResourceType
