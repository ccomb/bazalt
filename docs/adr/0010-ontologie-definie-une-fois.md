# 0010. L'ontologie n'est définie qu'une fois

Date : 2026-11-04. Statut : accepté.

## Contexte

`message/src/Payload.hs` et `studio/front/src/Payload.elm` sont des copies
tenues à la main. Elles ont divergé : `Event` et `Resource` n'ont plus les
mêmes champs des deux côtés, et un événement créé dans le navigateur ne se
décode probablement plus côté Haskell.

## Décision

Les types Haskell de `message` sont la seule définition de l'ontologie. Les
types Elm et leurs décodeurs JSON en sont générés (par exemple avec
`elm-street` ou `haskell-to-elm`), jamais écrits à la main.

## Conséquences

Une interface Elm ne peut pas construire un message que le côté Haskell ne
sait pas lire. Le choix de l'outil de génération reste ouvert.
