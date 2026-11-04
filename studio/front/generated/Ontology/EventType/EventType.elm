module Ontology.EventType.EventType exposing
    ( EventType
    , eventTypeDecoder
    , eventTypeEncoder
    )

import Json.Decode
import Json.Decode.Pipeline
import Json.Encode
import Maybe.Extra
import Ontology.Expression
import Ontology.Scope
import Ontology.Type
import Prng.Uuid


type alias EventType =
    { what : Ontology.Type.Type
    , uuid : Prng.Uuid.Uuid
    , parent : Maybe Prng.Uuid.Uuid
    , providers : Ontology.Scope.Scope
    , receivers : Ontology.Scope.Scope
    , resources : Ontology.Scope.Scope
    , createResource : Bool
    , qty : Ontology.Expression.Expression
    }


eventTypeEncoder : EventType -> Json.Encode.Value
eventTypeEncoder a =
    Json.Encode.object
        [ ( "what", Ontology.Type.typeEncoder a.what )
        , ( "uuid", Prng.Uuid.encode a.uuid )
        , ( "parent", Maybe.Extra.unwrap Json.Encode.null Prng.Uuid.encode a.parent )
        , ( "providers", Ontology.Scope.scopeEncoder a.providers )
        , ( "receivers", Ontology.Scope.scopeEncoder a.receivers )
        , ( "resources", Ontology.Scope.scopeEncoder a.resources )
        , ( "createResource", Json.Encode.bool a.createResource )
        , ( "qty", Ontology.Expression.expressionEncoder a.qty )
        ]


eventTypeDecoder : Json.Decode.Decoder EventType
eventTypeDecoder =
    Json.Decode.succeed EventType
        |> Json.Decode.Pipeline.required "what" Ontology.Type.typeDecoder
        |> Json.Decode.Pipeline.required "uuid" Prng.Uuid.decoder
        |> Json.Decode.Pipeline.required "parent" (Json.Decode.nullable Prng.Uuid.decoder)
        |> Json.Decode.Pipeline.required "providers" Ontology.Scope.scopeDecoder
        |> Json.Decode.Pipeline.required "receivers" Ontology.Scope.scopeDecoder
        |> Json.Decode.Pipeline.required "resources" Ontology.Scope.scopeDecoder
        |> Json.Decode.Pipeline.required "createResource" Json.Decode.bool
        |> Json.Decode.Pipeline.required "qty" Ontology.Expression.expressionDecoder
