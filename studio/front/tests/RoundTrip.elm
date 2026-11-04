port module RoundTrip exposing (main)

{-| Decodes each line it receives with the generated ontology and sends back
its re-encoding, or the decoding error. Driven by tests/roundtrip.mjs.
-}

import Json.Decode as Decode
import Json.Encode as Encode
import Ontology.Message exposing (messageDecoder, messageEncoder)


port line : (String -> msg) -> Sub msg


port result : String -> Cmd msg


main : Program () () String
main =
    Platform.worker
        { init = \_ -> ( (), Cmd.none )
        , update = \l _ -> ( (), result (roundTrip l) )
        , subscriptions = \_ -> line identity
        }


roundTrip : String -> String
roundTrip l =
    case Decode.decodeString messageDecoder l of
        Ok m ->
            Encode.encode 0 (messageEncoder m)

        Err e ->
            "Elm could not decode: " ++ String.replace "\n" " " (Decode.errorToString e)
