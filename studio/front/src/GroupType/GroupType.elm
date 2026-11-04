module GroupType.GroupType exposing (compare)

import Ontology.GroupType.GroupType exposing (GroupType)
import Prng.Uuid as Uuid


compare : GroupType -> String
compare =
    .uuid >> Uuid.toString
