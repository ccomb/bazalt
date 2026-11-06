module Service exposing (toString)


toString : Service -> String
toString s =
    case s of
        None ->
            "None"

        Front ->
            "Front"

        Studio ->
            "Studio"

        Dumb ->
            "Dumb"

        Store ->
            "Store"

        Ident ->
            "Ident"
