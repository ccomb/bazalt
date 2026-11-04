module Ident.Identifier exposing (compare, fromUuid, select, toValue, update)

import Dict exposing (Dict)
import Ident.Fragment as Fragment
import Ontology.Ident.Fragment exposing (Fragment)
import Ontology.Ident.Identifier exposing (Identifier)
import Prng.Uuid as Uuid exposing (Uuid)
import Type


select : String -> Dict String Identifier -> List Identifier
select name =
    Dict.filter (\_ i -> i.name == name) >> Dict.values


fromUuid : Uuid -> Dict String Identifier -> Dict String Identifier
fromUuid uuid =
    Dict.filter (\_ i -> uuid == i.for)


compare : Identifier -> String
compare i =
    Type.compare i.what ++ "/" ++ Uuid.toString i.for ++ "/" ++ i.name


toValue : Identifier -> String
toValue i =
    i.fragments |> List.map Fragment.toValue |> String.concat


update : Int -> Fragment -> Identifier -> Identifier
update index fragment identifier =
    let
        fragments =
            identifier.fragments
                |> List.indexedMap Tuple.pair
                |> List.map
                    (\( i, f ) ->
                        if i == index then
                            fragment

                        else
                            f
                    )
    in
    { identifier | fragments = fragments }
