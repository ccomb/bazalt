module Item.Item exposing (Item)

import Dict exposing (Dict)
import Ontology.Ident.Identifier exposing (Identifier)
import Ontology.Type exposing (Type)
import Ontology.Value.Value exposing (Value)
import Prng.Uuid exposing (Uuid)


type alias Item a =
    -- TODO could "what" be removed by turning all the items into a non-alias type?
    { a
        | what : Type
        , uuid : Uuid
        , identifiers : Dict String Identifier
        , values : Dict String Value
        , display : Dict String String
    }
