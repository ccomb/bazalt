module Expression.Observable exposing (allObs, toString)

import Ontology.Expression.Deeplink exposing (DeepLink(..))
import Ontology.Expression.Observable exposing (Observable(..))
import Ontology.Expression.ValueSelection exposing (ValueSelection(..))


allObs : List Observable
allObs =
    [ constant "", number "" "", ObsValue UndefinedValue, ObsLink Null ]


toString : Observable -> String
toString obs =
    case obs of
        Constant _ ->
            "Constant"

        Variable _ ->
            "Variable"

        ObsValue _ ->
            "Other Value"

        ObsLink _ ->
            "Deep link"


number : String -> String -> Observable
number name input =
    Variable { name = name, input = input }


constant : String -> Observable
constant =
    Constant
