module Ontology.AgentType.AgentType exposing
    ( AgentType
    , agentTypeDecoder
    , agentTypeEncoder
    )

import Json.Decode
import Json.Decode.Pipeline
import Json.Encode
import Maybe.Extra
import Ontology.Hierarchy.Type
import Prng.Uuid


type alias AgentType =
    { what : Ontology.Hierarchy.Type.Type
    , uuid : Prng.Uuid.Uuid
    , parent : Maybe Prng.Uuid.Uuid
    }


agentTypeEncoder : AgentType -> Json.Encode.Value
agentTypeEncoder a =
    Json.Encode.object
        [ ( "what", Ontology.Hierarchy.Type.typeEncoder a.what )
        , ( "uuid", Prng.Uuid.encode a.uuid )
        , ( "parent", Maybe.Extra.unwrap Json.Encode.null Prng.Uuid.encode a.parent )
        ]


agentTypeDecoder : Json.Decode.Decoder AgentType
agentTypeDecoder =
    Json.Decode.succeed AgentType
        |> Json.Decode.Pipeline.required "what" Ontology.Hierarchy.Type.typeDecoder
        |> Json.Decode.Pipeline.required "uuid" Prng.Uuid.decoder
        |> Json.Decode.Pipeline.required "parent" (Json.Decode.nullable Prng.Uuid.decoder)
