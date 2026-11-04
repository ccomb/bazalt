module Process.Reconcile exposing (byProcess, compare, filterByEvent, fromAllocations, toAllocations)

import Dict exposing (Dict)
import Expression.Rational as Rational
import Expression.RationalInput exposing (RationalInput)
import Ontology.Process.Reconcile exposing (Reconciliation)
import Prng.Uuid as Uuid exposing (Uuid)


byProcess : Uuid -> Dict String Reconciliation -> Dict String Reconciliation
byProcess uuid =
    Dict.filter (\_ r -> r.process == uuid)


filterByEvent : Uuid -> Dict String Reconciliation -> Dict String Reconciliation
filterByEvent uuid =
    Dict.filter (\_ r -> r.event == uuid)


compare : Reconciliation -> String
compare r =
    Uuid.toString r.event ++ "-" ++ Uuid.toString r.process


toAllocations : Dict String Reconciliation -> List ( Uuid, RationalInput )
toAllocations reconciliations =
    reconciliations
        |> Dict.values
        |> List.map (\r -> ( r.process, Rational.toFloatString r.qty ))


fromAllocations : Uuid -> List ( Uuid, RationalInput ) -> Dict String Reconciliation
fromAllocations event partialProcesses =
    partialProcesses
        |> List.foldl
            (\( process, sqty ) aggregate ->
                case Rational.fromString sqty of
                    Ok qty ->
                        let
                            r =
                                { qty = qty, event = event, process = process }
                        in
                        Dict.insert (compare r) r aggregate

                    Err _ ->
                        aggregate
            )
            Dict.empty
