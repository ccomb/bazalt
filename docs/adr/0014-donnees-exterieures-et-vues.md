# 0014. Données extérieures et vues calculées sont des capacités

Date : 2026-11-04. Statut : accepté.

## Décision

Un cours de change, une analyse de laboratoire ou une donnée climatique
entre par une capacité dédiée (un connecteur). Celle-ci écrit des faits
d'observation datés, avec leur source. Une formule ne lit que des
observations déjà présentes dans le journal, et un calcul se refait donc
toujours à l'identique.

Les soldes (patron *Account*), le stock disponible, les créances ouvertes et
l'échéancier par devise sont calculés par une capacité de calcul de soldes,
qui tient son propre état. Une interface affiche ces vues et ne refait aucun
calcul métier. Une vue impossible à calculer, par exemple un solde entre
deux types de ressources sans équivalence, est signalée, jamais remplacée
par zéro.
