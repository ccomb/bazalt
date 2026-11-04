# 0010. L'ontologie n'est définie qu'une fois

Date : 2026-11-04. Statut : accepté.

## Contexte

`message/src/Payload.hs` et `studio/front/src/Payload.elm` sont des copies
tenues à la main. Elles ont divergé : `Event` et `Resource` n'ont plus les
mêmes champs des deux côtés, et un événement créé dans le navigateur ne se
décode probablement plus côté Haskell.

## Décision

Les types Haskell de `message` sont la seule définition de l'ontologie. Les
types Elm et leurs codecs JSON en sont générés, jamais écrits à la main.

L'outil retenu est `haskell-to-elm` (0.3.2.0). Il produit des codecs qui
suivent les `aeson.Options` du côté Haskell : le format JSON reste celui que
les services écrivent déjà dans leurs journaux. `elm-street` aurait imposé
son propre format, et donc changé le JSON de tous les services pour plaire au
générateur.

Le générateur (`gen-elm/`) écrit les modules `Ontology.*` dans
`studio/front/generated/`, qui est versionné. Seul `Ontology.Prim` est écrit
à la main : il donne la forme JSON des instants (un nombre de secondes) et
des rationnels (un numérateur et un dénominateur), comme `aeson` les écrit.

## Conséquences

Une interface Elm ne peut pas construire un message que le côté Haskell ne
sait pas lire. Deux scripts le vérifient : `gen-elm/check.sh` refuse un code
généré qui ne correspond plus aux types Haskell (le build du studio le lance),
et `gen-elm/roundtrip.sh` fait passer des milliers de messages aléatoires de
Haskell à Elm puis de nouveau à Haskell.

Là où le modèle Elm écrit à la main était le plus riche (la distinction entre
une entité et un type d'entité, la forme des liens profonds), le côté Haskell
l'a d'abord adopté : une seule définition ne veut pas dire que le côté
Haskell avait toujours raison.
