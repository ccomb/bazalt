module Ontology.Typed.Type exposing
    ( Type(..)
    , typeDecoder
    , typeEncoder
    )

import Json.Decode
import Json.Encode


type Type
    = Resource
    | Event
    | Agent
    | Commitment
    | Contract
    | Process
    | Group


typeEncoder : Type -> Json.Encode.Value
typeEncoder a =
    case a of
        Resource ->
            Json.Encode.string "Resource"

        Event ->
            Json.Encode.string "Event"

        Agent ->
            Json.Encode.string "Agent"

        Commitment ->
            Json.Encode.string "Commitment"

        Contract ->
            Json.Encode.string "Contract"

        Process ->
            Json.Encode.string "Process"

        Group ->
            Json.Encode.string "Group"


typeDecoder : Json.Decode.Decoder Type
typeDecoder =
    Json.Decode.string
        |> Json.Decode.andThen
            (\a ->
                case a of
                    "Resource" ->
                        Json.Decode.succeed Resource

                    "Event" ->
                        Json.Decode.succeed Event

                    "Agent" ->
                        Json.Decode.succeed Agent

                    "Commitment" ->
                        Json.Decode.succeed Commitment

                    "Contract" ->
                        Json.Decode.succeed Contract

                    "Process" ->
                        Json.Decode.succeed Process

                    "Group" ->
                        Json.Decode.succeed Group

                    _ ->
                        Json.Decode.fail "No matching constructor"
            )
