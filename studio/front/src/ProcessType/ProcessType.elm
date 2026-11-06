module ProcessType.ProcessType exposing (compare)

import Prng.Uuid as Uuid


compare : ProcessType -> String
compare =
    Uuid.toString << .uuid
