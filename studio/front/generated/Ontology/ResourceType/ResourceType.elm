module Ontology.ResourceType.ResourceType exposing
    ( ResourceType
    , resourceTypeDecoder
    , resourceTypeEncoder
    )

import Json.Decode
import Json.Decode.Pipeline
import Json.Encode
import Maybe.Extra
import Ontology.Type
import Prng.Uuid


type alias ResourceType =
    { what : Ontology.Type.Type
    , uuid : Prng.Uuid.Uuid
    , parent : Maybe Prng.Uuid.Uuid
    }


resourceTypeEncoder : ResourceType -> Json.Encode.Value
resourceTypeEncoder a =
    Json.Encode.object
        [ ( "what", Ontology.Type.typeEncoder a.what )
        , ( "uuid", Prng.Uuid.encode a.uuid )
        , ( "parent", Maybe.Extra.unwrap Json.Encode.null Prng.Uuid.encode a.parent )
        ]


resourceTypeDecoder : Json.Decode.Decoder ResourceType
resourceTypeDecoder =
    Json.Decode.succeed ResourceType
        |> Json.Decode.Pipeline.required "what" Ontology.Type.typeDecoder
        |> Json.Decode.Pipeline.required "uuid" Prng.Uuid.decoder
        |> Json.Decode.Pipeline.required "parent" (Json.Decode.nullable Prng.Uuid.decoder)
