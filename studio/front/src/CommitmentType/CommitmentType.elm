module CommitmentType.CommitmentType exposing (compare)

import Prng.Uuid as Uuid


compare : CommitmentType -> String
compare =
    toString


toString : CommitmentType -> String
toString =
    .uuid >> Uuid.toString
