module Ontology.Commitment.Commitment exposing
    ( Commitment
    , commitmentDecoder
    , commitmentEncoder
    )

import Json.Decode
import Json.Decode.Pipeline
import Json.Encode
import Ontology.Expression
import Ontology.Flow
import Ontology.Prim
import Ontology.Type
import Prng.Uuid
import Time


type alias Commitment =
    { what : Ontology.Type.Type
    , uuid : Prng.Uuid.Uuid
    , when : Time.Posix
    , qty : Ontology.Expression.Expression
    , type_ : Prng.Uuid.Uuid
    , provider : Prng.Uuid.Uuid
    , receiver : Prng.Uuid.Uuid
    , flow : Ontology.Flow.Flow
    }


commitmentEncoder : Commitment -> Json.Encode.Value
commitmentEncoder a =
    Json.Encode.object
        [ ( "what", Ontology.Type.typeEncoder a.what )
        , ( "uuid", Prng.Uuid.encode a.uuid )
        , ( "when", Ontology.Prim.posixEncoder a.when )
        , ( "qty", Ontology.Expression.expressionEncoder a.qty )
        , ( "type_", Prng.Uuid.encode a.type_ )
        , ( "provider", Prng.Uuid.encode a.provider )
        , ( "receiver", Prng.Uuid.encode a.receiver )
        , ( "flow", Ontology.Flow.flowEncoder a.flow )
        ]


commitmentDecoder : Json.Decode.Decoder Commitment
commitmentDecoder =
    Json.Decode.succeed Commitment
        |> Json.Decode.Pipeline.required "what" Ontology.Type.typeDecoder
        |> Json.Decode.Pipeline.required "uuid" Prng.Uuid.decoder
        |> Json.Decode.Pipeline.required "when" Ontology.Prim.posixDecoder
        |> Json.Decode.Pipeline.required "qty" Ontology.Expression.expressionDecoder
        |> Json.Decode.Pipeline.required "type_" Prng.Uuid.decoder
        |> Json.Decode.Pipeline.required "provider" Prng.Uuid.decoder
        |> Json.Decode.Pipeline.required "receiver" Prng.Uuid.decoder
        |> Json.Decode.Pipeline.required "flow" Ontology.Flow.flowDecoder
