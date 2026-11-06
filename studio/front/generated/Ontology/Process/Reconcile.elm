module Ontology.Process.Reconcile exposing
    ( Reconciliation
    , reconciliationDecoder
    , reconciliationEncoder
    )

import Json.Decode
import Json.Decode.Pipeline
import Json.Encode
import Ontology.Prim
import Prng.Uuid


type alias Reconciliation =
    { qty : Ontology.Prim.Rational
    , event : Prng.Uuid.Uuid
    , process : Prng.Uuid.Uuid
    }


reconciliationEncoder : Reconciliation -> Json.Encode.Value
reconciliationEncoder a =
    Json.Encode.object
        [ ( "qty", Ontology.Prim.rationalEncoder a.qty )
        , ( "event", Prng.Uuid.encode a.event )
        , ( "process", Prng.Uuid.encode a.process )
        ]


reconciliationDecoder : Json.Decode.Decoder Reconciliation
reconciliationDecoder =
    Json.Decode.succeed Reconciliation
        |> Json.Decode.Pipeline.required "qty" Ontology.Prim.rationalDecoder
        |> Json.Decode.Pipeline.required "event" Prng.Uuid.decoder
        |> Json.Decode.Pipeline.required "process" Prng.Uuid.decoder
