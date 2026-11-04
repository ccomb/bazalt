module Group.Link exposing (compare)

import Ontology.Group.Link exposing (Link)
import Prng.Uuid as Uuid


compare : Link -> String
compare link =
    Uuid.toString link.groupable ++ ":" ++ Uuid.toString link.group
