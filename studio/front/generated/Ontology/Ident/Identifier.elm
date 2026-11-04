module Ontology.Ident.Identifier exposing
    ( Identifier
    , identifierDecoder
    , identifierEncoder
    )

import Json.Decode
import Json.Decode.Pipeline
import Json.Encode
import Ontology.Ident.Fragment
import Ontology.Type
import Prng.Uuid


type alias Identifier =
    { what : Ontology.Type.Type
    , for : Prng.Uuid.Uuid
    , name : String
    , fragments : List Ontology.Ident.Fragment.Fragment
    }


identifierEncoder : Identifier -> Json.Encode.Value
identifierEncoder a =
    Json.Encode.object
        [ ( "what", Ontology.Type.typeEncoder a.what )
        , ( "for", Prng.Uuid.encode a.for )
        , ( "name", Json.Encode.string a.name )
        , ( "fragments", Json.Encode.list Ontology.Ident.Fragment.fragmentEncoder a.fragments )
        ]


identifierDecoder : Json.Decode.Decoder Identifier
identifierDecoder =
    Json.Decode.succeed Identifier
        |> Json.Decode.Pipeline.required "what" Ontology.Type.typeDecoder
        |> Json.Decode.Pipeline.required "for" Prng.Uuid.decoder
        |> Json.Decode.Pipeline.required "name" Json.Decode.string
        |> Json.Decode.Pipeline.required "fragments" (Json.Decode.list Ontology.Ident.Fragment.fragmentDecoder)
