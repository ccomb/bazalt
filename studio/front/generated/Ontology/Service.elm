module Ontology.Service exposing
    ( Service(..)
    , serviceDecoder
    , serviceEncoder
    )

import Json.Decode
import Json.Encode


type Service
    = None
    | Front
    | Studio
    | Dumb
    | Store
    | Ident


serviceEncoder : Service -> Json.Encode.Value
serviceEncoder a =
    case a of
        None ->
            Json.Encode.string "None"

        Front ->
            Json.Encode.string "Front"

        Studio ->
            Json.Encode.string "Studio"

        Dumb ->
            Json.Encode.string "Dumb"

        Store ->
            Json.Encode.string "Store"

        Ident ->
            Json.Encode.string "Ident"


serviceDecoder : Json.Decode.Decoder Service
serviceDecoder =
    Json.Decode.string
        |> Json.Decode.andThen
            (\a ->
                case a of
                    "None" ->
                        Json.Decode.succeed None

                    "Front" ->
                        Json.Decode.succeed Front

                    "Studio" ->
                        Json.Decode.succeed Studio

                    "Dumb" ->
                        Json.Decode.succeed Dumb

                    "Store" ->
                        Json.Decode.succeed Store

                    "Ident" ->
                        Json.Decode.succeed Ident

                    _ ->
                        Json.Decode.fail "No matching constructor"
            )
