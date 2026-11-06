{- | The JSON shape of every message type, defined once. The Elm generator
reads the same options, so both sides always agree on the wire format.
-}
module Json (taggedOptions, payloadOptions) where

import Data.Aeson (Options (..), SumEncoding (..), defaultOptions)

{- | Constructors tagged by @type@, their contents under @value@. A type
whose constructors carry nothing is written as a plain string.
-}
taggedOptions :: Options
taggedOptions = defaultOptions{sumEncoding = TaggedObject{tagFieldName = "type", contentsFieldName = "value"}}

-- | A payload is tagged by @what@, its contents under @load@.
payloadOptions :: Options
payloadOptions = defaultOptions{sumEncoding = TaggedObject{tagFieldName = "what", contentsFieldName = "load"}}
