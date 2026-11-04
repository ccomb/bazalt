module Configuration.Zone exposing (all, compare, toDesc)

import Ontology.Configuration.Zone exposing (Zone(..))


all : List Zone
all =
    [ SmallcardZone, MenuZone ]


toString : Zone -> String
toString zone =
    case zone of
        SmallcardZone ->
            "SmallcardZone"

        MenuZone ->
            "MenuZone"


toDesc : Zone -> String
toDesc zone =
    case zone of
        SmallcardZone ->
            "Smallcard Title"

        MenuZone ->
            "Menu Title"


compare : Zone -> String
compare =
    toString
