module Ontology.Contract.Contract exposing
    ( Contract
    , contractDecoder
    , contractEncoder
    )

import Json.Decode
import Json.Decode.Pipeline
import Json.Encode
import Ontology.Type
import Prng.Uuid


type alias Contract =
    { what : Ontology.Type.Type, uuid : Prng.Uuid.Uuid, type_ : Prng.Uuid.Uuid }


contractEncoder : Contract -> Json.Encode.Value
contractEncoder a =
    Json.Encode.object
        [ ( "what", Ontology.Type.typeEncoder a.what )
        , ( "uuid", Prng.Uuid.encode a.uuid )
        , ( "type_", Prng.Uuid.encode a.type_ )
        ]


contractDecoder : Json.Decode.Decoder Contract
contractDecoder =
    Json.Decode.succeed Contract
        |> Json.Decode.Pipeline.required "what" Ontology.Type.typeDecoder
        |> Json.Decode.Pipeline.required "uuid" Prng.Uuid.decoder
        |> Json.Decode.Pipeline.required "type_" Prng.Uuid.decoder
