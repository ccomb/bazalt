module Ontology.Group.Group exposing
    ( Group
    , groupDecoder
    , groupEncoder
    )

import Json.Decode
import Json.Decode.Pipeline
import Json.Encode
import Maybe.Extra
import Ontology.Scope
import Ontology.Typed.Type
import Prng.Uuid


type alias Group =
    { what : Ontology.Typed.Type.Type
    , uuid : Prng.Uuid.Uuid
    , type_ : Prng.Uuid.Uuid
    , parent : Maybe Prng.Uuid.Uuid
    , scope : Ontology.Scope.Scope
    }


groupEncoder : Group -> Json.Encode.Value
groupEncoder a =
    Json.Encode.object
        [ ( "what", Ontology.Typed.Type.typeEncoder a.what )
        , ( "uuid", Prng.Uuid.encode a.uuid )
        , ( "type_", Prng.Uuid.encode a.type_ )
        , ( "parent", Maybe.Extra.unwrap Json.Encode.null Prng.Uuid.encode a.parent )
        , ( "scope", Ontology.Scope.scopeEncoder a.scope )
        ]


groupDecoder : Json.Decode.Decoder Group
groupDecoder =
    Json.Decode.succeed Group
        |> Json.Decode.Pipeline.required "what" Ontology.Typed.Type.typeDecoder
        |> Json.Decode.Pipeline.required "uuid" Prng.Uuid.decoder
        |> Json.Decode.Pipeline.required "type_" Prng.Uuid.decoder
        |> Json.Decode.Pipeline.required "parent" (Json.Decode.nullable Prng.Uuid.decoder)
        |> Json.Decode.Pipeline.required "scope" Ontology.Scope.scopeDecoder
