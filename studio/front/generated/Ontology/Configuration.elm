module Ontology.Configuration exposing
    ( Configuration(..)
    , configurationDecoder
    , configurationEncoder
    )

import Json.Decode
import Json.Decode.Pipeline
import Json.Encode
import Ontology.Configuration.Zone
import Ontology.Configuration.Zone.Fragment
import Ontology.Hierarchy.Type
import Ontology.Scope
import Prng.Uuid


type Configuration
    = ZoneDisplay
        { zone : Ontology.Configuration.Zone.Zone
        , fragments : List Ontology.Configuration.Zone.Fragment.Fragment
        , scope : Ontology.Scope.Scope
        }
    | MenuDisplay
        { what : Ontology.Hierarchy.Type.Type
        , uuid : Prng.Uuid.Uuid
        , isMenu : Bool
        }


configurationEncoder : Configuration -> Json.Encode.Value
configurationEncoder a =
    case a of
        ZoneDisplay b ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "ZoneDisplay" )
                , ( "zone", Ontology.Configuration.Zone.zoneEncoder b.zone )
                , ( "fragments", Json.Encode.list Ontology.Configuration.Zone.Fragment.fragmentEncoder b.fragments )
                , ( "scope", Ontology.Scope.scopeEncoder b.scope )
                ]

        MenuDisplay b ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "MenuDisplay" )
                , ( "what", Ontology.Hierarchy.Type.typeEncoder b.what )
                , ( "uuid", Prng.Uuid.encode b.uuid )
                , ( "isMenu", Json.Encode.bool b.isMenu )
                ]


configurationDecoder : Json.Decode.Decoder Configuration
configurationDecoder =
    Json.Decode.field "type" Json.Decode.string
        |> Json.Decode.andThen
            (\a ->
                case a of
                    "ZoneDisplay" ->
                        Json.Decode.map ZoneDisplay
                            (Json.Decode.succeed
                                (\b c d ->
                                    { zone = b
                                    , fragments = c
                                    , scope = d
                                    }
                                )
                                |> Json.Decode.Pipeline.required "zone" Ontology.Configuration.Zone.zoneDecoder
                                |> Json.Decode.Pipeline.required "fragments" (Json.Decode.list Ontology.Configuration.Zone.Fragment.fragmentDecoder)
                                |> Json.Decode.Pipeline.required "scope" Ontology.Scope.scopeDecoder
                            )

                    "MenuDisplay" ->
                        Json.Decode.map MenuDisplay
                            (Json.Decode.succeed
                                (\b c d ->
                                    { what = b
                                    , uuid = c
                                    , isMenu = d
                                    }
                                )
                                |> Json.Decode.Pipeline.required "what" Ontology.Hierarchy.Type.typeDecoder
                                |> Json.Decode.Pipeline.required "uuid" Prng.Uuid.decoder
                                |> Json.Decode.Pipeline.required "isMenu" Json.Decode.bool
                            )

                    _ ->
                        Json.Decode.fail "No matching constructor"
            )
