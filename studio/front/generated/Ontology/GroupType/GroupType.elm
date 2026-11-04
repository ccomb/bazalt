module Ontology.GroupType.GroupType exposing
    ( GroupType
    , groupTypeDecoder
    , groupTypeEncoder
    )

import Json.Decode
import Json.Decode.Pipeline
import Json.Encode
import Maybe.Extra
import Ontology.Hierarchy.Type
import Ontology.Tree
import Prng.Uuid


type alias GroupType =
    { what : Ontology.Hierarchy.Type.Type
    , uuid : Prng.Uuid.Uuid
    , parent : Maybe Prng.Uuid.Uuid
    , unique : Bool
    , treeType : Ontology.Tree.TreeType
    }


groupTypeEncoder : GroupType -> Json.Encode.Value
groupTypeEncoder a =
    Json.Encode.object
        [ ( "what", Ontology.Hierarchy.Type.typeEncoder a.what )
        , ( "uuid", Prng.Uuid.encode a.uuid )
        , ( "parent", Maybe.Extra.unwrap Json.Encode.null Prng.Uuid.encode a.parent )
        , ( "unique", Json.Encode.bool a.unique )
        , ( "treeType", Ontology.Tree.treeTypeEncoder a.treeType )
        ]


groupTypeDecoder : Json.Decode.Decoder GroupType
groupTypeDecoder =
    Json.Decode.succeed GroupType
        |> Json.Decode.Pipeline.required "what" Ontology.Hierarchy.Type.typeDecoder
        |> Json.Decode.Pipeline.required "uuid" Prng.Uuid.decoder
        |> Json.Decode.Pipeline.required "parent" (Json.Decode.nullable Prng.Uuid.decoder)
        |> Json.Decode.Pipeline.required "unique" Json.Decode.bool
        |> Json.Decode.Pipeline.required "treeType" Ontology.Tree.treeTypeDecoder
