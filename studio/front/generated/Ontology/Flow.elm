module Ontology.Flow exposing
    ( Flow(..)
    , flowDecoder
    , flowEncoder
    )

import Json.Decode
import Json.Decode.Pipeline
import Json.Encode
import Ontology.Resource.Resource
import Ontology.ResourceType.ResourceType


type Flow
    = ResourceFlow Ontology.Resource.Resource.Resource
    | ResourceTypeFlow Ontology.ResourceType.ResourceType.ResourceType


flowEncoder : Flow -> Json.Encode.Value
flowEncoder a =
    case a of
        ResourceFlow b ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "ResourceFlow" )
                , ( "value", Ontology.Resource.Resource.resourceEncoder b )
                ]

        ResourceTypeFlow b ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "ResourceTypeFlow" )
                , ( "value", Ontology.ResourceType.ResourceType.resourceTypeEncoder b )
                ]


flowDecoder : Json.Decode.Decoder Flow
flowDecoder =
    Json.Decode.field "type" Json.Decode.string
        |> Json.Decode.andThen
            (\a ->
                case a of
                    "ResourceFlow" ->
                        Json.Decode.succeed ResourceFlow
                            |> Json.Decode.Pipeline.required "value" Ontology.Resource.Resource.resourceDecoder

                    "ResourceTypeFlow" ->
                        Json.Decode.succeed ResourceTypeFlow
                            |> Json.Decode.Pipeline.required "value" Ontology.ResourceType.ResourceType.resourceTypeDecoder

                    _ ->
                        Json.Decode.fail "No matching constructor"
            )
