module Ontology.Configuration.Zone exposing
    ( Zone(..)
    , zoneDecoder
    , zoneEncoder
    )

import Json.Decode
import Json.Encode


type Zone
    = SmallcardZone
    | MenuZone


zoneEncoder : Zone -> Json.Encode.Value
zoneEncoder a =
    case a of
        SmallcardZone ->
            Json.Encode.string "SmallcardZone"

        MenuZone ->
            Json.Encode.string "MenuZone"


zoneDecoder : Json.Decode.Decoder Zone
zoneDecoder =
    Json.Decode.string
        |> Json.Decode.andThen
            (\a ->
                case a of
                    "SmallcardZone" ->
                        Json.Decode.succeed SmallcardZone

                    "MenuZone" ->
                        Json.Decode.succeed MenuZone

                    _ ->
                        Json.Decode.fail "No matching constructor"
            )
