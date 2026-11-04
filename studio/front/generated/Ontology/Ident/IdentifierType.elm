module Ontology.Ident.IdentifierType exposing
    ( IdentifierType
    , identifierTypeDecoder
    , identifierTypeEncoder
    )

import Json.Decode
import Json.Decode.Pipeline
import Json.Encode
import Ontology.Ident.Fragment
import Ontology.Scope


type alias IdentifierType =
    { name : String
    , fragments : List Ontology.Ident.Fragment.Fragment
    , scope : Ontology.Scope.Scope
    , unique : Bool
    , mandatory : Bool
    }


identifierTypeEncoder : IdentifierType -> Json.Encode.Value
identifierTypeEncoder a =
    Json.Encode.object
        [ ( "name", Json.Encode.string a.name )
        , ( "fragments", Json.Encode.list Ontology.Ident.Fragment.fragmentEncoder a.fragments )
        , ( "scope", Ontology.Scope.scopeEncoder a.scope )
        , ( "unique", Json.Encode.bool a.unique )
        , ( "mandatory", Json.Encode.bool a.mandatory )
        ]


identifierTypeDecoder : Json.Decode.Decoder IdentifierType
identifierTypeDecoder =
    Json.Decode.succeed IdentifierType
        |> Json.Decode.Pipeline.required "name" Json.Decode.string
        |> Json.Decode.Pipeline.required "fragments" (Json.Decode.list Ontology.Ident.Fragment.fragmentDecoder)
        |> Json.Decode.Pipeline.required "scope" Ontology.Scope.scopeDecoder
        |> Json.Decode.Pipeline.required "unique" Json.Decode.bool
        |> Json.Decode.Pipeline.required "mandatory" Json.Decode.bool
