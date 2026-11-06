module Process.Reconcile.View exposing (viewAsEvent, viewAsProcess)

import Configuration.Zone.View exposing (displayZone)
import Dict
import Element exposing (Element, text)
import Expression.Rational as Rational
import Ontology.Configuration.Zone exposing (Zone(..))
import Ontology.Hierarchy.Type as HType
import Ontology.Process.Reconcile exposing (Reconciliation)
import Ontology.Type as Type
import Ontology.Typed.Type as TType
import Prng.Uuid as Uuid exposing (Uuid)
import State exposing (State)
import Util exposing (third)
import View.Smallcard exposing (clickableRemovableCard)


view : State -> (Uuid -> msg) -> (Reconciliation -> msg) -> Reconciliation -> Uuid -> Element msg
view s onChoose onDelete r target =
    clickableRemovableCard
        (onChoose target)
        (onDelete r)
        (text <| Rational.toFloatString r.qty ++ " / " ++ displayZone s SmallcardZone (Type.TType TType.Event) target)
        (Dict.get (Uuid.toString r.event) s.types
            |> Maybe.andThen third
            |> Maybe.map (\puuid -> displayZone s SmallcardZone {- TODO check?(Identifier.fromUuid puuid ids) -} (Type.HType HType.EventType) puuid)
            |> Maybe.withDefault ""
            |> text
        )


viewAsProcess : State -> (Uuid -> msg) -> (Reconciliation -> msg) -> Reconciliation -> Element msg
viewAsProcess s onChoose onDelete r =
    view s onChoose onDelete r r.process


viewAsEvent : State -> (Uuid -> msg) -> (Reconciliation -> msg) -> Reconciliation -> Element msg
viewAsEvent s onChoose onDelete r =
    view s onChoose onDelete r r.event
