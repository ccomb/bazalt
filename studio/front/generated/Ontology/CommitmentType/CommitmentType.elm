module Ontology.CommitmentType.CommitmentType exposing
    ( CommitmentType
    , commitmentTypeDecoder
    , commitmentTypeEncoder
    )

import Json.Decode
import Json.Decode.Pipeline
import Json.Encode
import Maybe.Extra
import Ontology.Expression
import Ontology.Hierarchy.Type
import Ontology.Scope
import Prng.Uuid


type alias CommitmentType =
    { what : Ontology.Hierarchy.Type.Type
    , uuid : Prng.Uuid.Uuid
    , parent : Maybe Prng.Uuid.Uuid
    , providers : Ontology.Scope.Scope
    , receivers : Ontology.Scope.Scope
    , flowscope : Ontology.Scope.Scope
    , qty : Ontology.Expression.Expression
    }


commitmentTypeEncoder : CommitmentType -> Json.Encode.Value
commitmentTypeEncoder a =
    Json.Encode.object
        [ ( "what", Ontology.Hierarchy.Type.typeEncoder a.what )
        , ( "uuid", Prng.Uuid.encode a.uuid )
        , ( "parent", Maybe.Extra.unwrap Json.Encode.null Prng.Uuid.encode a.parent )
        , ( "providers", Ontology.Scope.scopeEncoder a.providers )
        , ( "receivers", Ontology.Scope.scopeEncoder a.receivers )
        , ( "flowscope", Ontology.Scope.scopeEncoder a.flowscope )
        , ( "qty", Ontology.Expression.expressionEncoder a.qty )
        ]


commitmentTypeDecoder : Json.Decode.Decoder CommitmentType
commitmentTypeDecoder =
    Json.Decode.succeed CommitmentType
        |> Json.Decode.Pipeline.required "what" Ontology.Hierarchy.Type.typeDecoder
        |> Json.Decode.Pipeline.required "uuid" Prng.Uuid.decoder
        |> Json.Decode.Pipeline.required "parent" (Json.Decode.nullable Prng.Uuid.decoder)
        |> Json.Decode.Pipeline.required "providers" Ontology.Scope.scopeDecoder
        |> Json.Decode.Pipeline.required "receivers" Ontology.Scope.scopeDecoder
        |> Json.Decode.Pipeline.required "flowscope" Ontology.Scope.scopeDecoder
        |> Json.Decode.Pipeline.required "qty" Ontology.Expression.expressionDecoder
