module Ontology.Tree exposing
    ( TreeType(..)
    , treeTypeDecoder
    , treeTypeEncoder
    )

import Json.Decode
import Json.Encode


type TreeType
    = Flat
    | Node
    | Leaf


treeTypeEncoder : TreeType -> Json.Encode.Value
treeTypeEncoder a =
    case a of
        Flat ->
            Json.Encode.string "Flat"

        Node ->
            Json.Encode.string "Node"

        Leaf ->
            Json.Encode.string "Leaf"


treeTypeDecoder : Json.Decode.Decoder TreeType
treeTypeDecoder =
    Json.Decode.string
        |> Json.Decode.andThen
            (\a ->
                case a of
                    "Flat" ->
                        Json.Decode.succeed Flat

                    "Node" ->
                        Json.Decode.succeed Node

                    "Leaf" ->
                        Json.Decode.succeed Leaf

                    _ ->
                        Json.Decode.fail "No matching constructor"
            )
