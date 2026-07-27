module Conversion exposing (..)

import Expression.Rational exposing (Rational)
import Flow exposing (Flow)
import Prng.Uuid as Uuid exposing (Uuid)
import Time


type alias Conversion =
    { from : Time.Posix
    , until : Time.Posix
    , what : ( Rational, RT ) or R
    , equiv : ( Rational, Flow )
    , who : Uuid -- Agent for which the conversion is relevant

    -- location ? -- the price of a resource depends on the location or geo zone
    }



{-
   Signifie qu'à la date donnée le prix était le suivant. Chaque conversion change le prix.
   Comment définir un prix accordé ? via un commitement. Comment savoir qu'il y un commitment ? Il doit être dans le process.
   De quoi peut dépendre le prix ? de la date, du client, d'une formule (H*W). event→receiver→group

   BOM : Linkage : R-R avec notion de parent/composant.
   R m2o R parent

   Specification :
   RT - RT qui décrit un plan de ce qui doit être

   Price :
   RT Int RT
   R Int RT

   On crée un event adhésion, on met le A acheteur et le A vendeur, on met la qté de RT ou de R (flow) qui est échangée, on récupère depuis les conversions les différentes valeurs en RT et on les propose au choix.


-}
