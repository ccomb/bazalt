module Ontology.ContractType.ContractType exposing
    ( ContractType
    , contractTypeDecoder
    , contractTypeEncoder
    )

import Json.Decode
import Json.Decode.Pipeline
import Json.Encode
import Maybe.Extra
import Ontology.Type
import Prng.Uuid


type alias ContractType =
    { what : Ontology.Type.Type
    , uuid : Prng.Uuid.Uuid
    , parent : Maybe Prng.Uuid.Uuid
    }


contractTypeEncoder : ContractType -> Json.Encode.Value
contractTypeEncoder a =
    Json.Encode.object
        [ ( "what", Ontology.Type.typeEncoder a.what )
        , ( "uuid", Prng.Uuid.encode a.uuid )
        , ( "parent", Maybe.Extra.unwrap Json.Encode.null Prng.Uuid.encode a.parent )
        ]


contractTypeDecoder : Json.Decode.Decoder ContractType
contractTypeDecoder =
    Json.Decode.succeed ContractType
        |> Json.Decode.Pipeline.required "what" Ontology.Type.typeDecoder
        |> Json.Decode.Pipeline.required "uuid" Prng.Uuid.decoder
        |> Json.Decode.Pipeline.required "parent" (Json.Decode.nullable Prng.Uuid.decoder)
