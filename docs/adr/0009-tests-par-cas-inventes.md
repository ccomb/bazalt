# 0009. Les tests sont des cas inventés, inspirés de clients réels

Date : 2026-11-04. Statut : accepté.

## Contexte

Aucune configuration de client réel n'entre dans ce dépôt
([ADR 0007](0007-configuration-dans-le-journal.md)). Les exemples du livre de
Hruby sont liés à son code source et ne sont pas assez génériques pour servir
de tests tels quels.

## Décision

Chaque test est un journal (faits de configuration puis faits métier) avec,
en sortie, les états attendus (soldes, créances, réservations, échéances) et
les refus attendus, chacun avec sa raison.

Les cas sont inventés. Ils s'inspirent de situations réelles : un
importateur de fruits (achats multidevises, stock réservé, échéancier de
trésorerie), une association d'adhérents (adhésion, cotisation par barème,
lettrage) et des cas des chapitres 7 à 10
du livre (prêt, bon de commande, transport, pénalité). Aucun ne reprend de
donnée réelle.

Chaque patron REA de la liste de contrôle
([ADR 0006](0006-couverture-rea-par-les-cas.md)) est couvert par au moins un
cas.
