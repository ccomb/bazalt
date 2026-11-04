module Ontology.Message exposing
    ( Message
    , messageDecoder
    , messageEncoder
    )

import Json.Decode
import Json.Decode.Pipeline
import Json.Encode
import Ontology.Metadata
import Ontology.Payload


type alias Message =
    { meta : Ontology.Metadata.Metadata, load : Ontology.Payload.Payload }


messageEncoder : Message -> Json.Encode.Value
messageEncoder a =
    Json.Encode.object
        [ ( "meta", Ontology.Metadata.metadataEncoder a.meta )
        , ( "load", Ontology.Payload.payloadEncoder a.load )
        ]


messageDecoder : Json.Decode.Decoder Message
messageDecoder =
    Json.Decode.succeed Message
        |> Json.Decode.Pipeline.required "meta" Ontology.Metadata.metadataDecoder
        |> Json.Decode.Pipeline.required "load" Ontology.Payload.payloadDecoder
