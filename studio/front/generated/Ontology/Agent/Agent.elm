module Ontology.Agent.Agent exposing
    ( Agent
    , agentDecoder
    , agentEncoder
    )

import Json.Decode
import Json.Decode.Pipeline
import Json.Encode
import Ontology.Typed.Type
import Prng.Uuid


type alias Agent =
    { what : Ontology.Typed.Type.Type
    , uuid : Prng.Uuid.Uuid
    , type_ : Prng.Uuid.Uuid
    }


agentEncoder : Agent -> Json.Encode.Value
agentEncoder a =
    Json.Encode.object
        [ ( "what", Ontology.Typed.Type.typeEncoder a.what )
        , ( "uuid", Prng.Uuid.encode a.uuid )
        , ( "type_", Prng.Uuid.encode a.type_ )
        ]


agentDecoder : Json.Decode.Decoder Agent
agentDecoder =
    Json.Decode.succeed Agent
        |> Json.Decode.Pipeline.required "what" Ontology.Typed.Type.typeDecoder
        |> Json.Decode.Pipeline.required "uuid" Prng.Uuid.decoder
        |> Json.Decode.Pipeline.required "type_" Prng.Uuid.decoder
