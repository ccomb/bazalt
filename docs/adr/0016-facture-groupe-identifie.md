# 0016. Une facture est un groupe identifié, pas une notion de l'ontologie

Date : 2026-11-06. Statut : accepté.

## Contexte

Le livre de Hruby fait de la facture une *Materialized Claim* : le
déséquilibre d'un échange rendu visible. La notion reste floue, car une
facture joue trois rôles à la fois : elle décrit une transaction, elle
demande un paiement et elle sert de trace légale.

La comptabilité ajoute un quatrième regard. Une facture de vente de 6 720 €
HT s'y enregistre en trois écritures : 8 064 € au débit du client (411),
6 720 € au crédit des ventes (707), 1 344 € au crédit de la TVA collectée
(44571). Aucune de ces écritures n'est un fait. Le solde client se calcule
(livré moins payé), la vente est la valeur en euros d'une livraison, et la
TVA est un engagement envers un troisième agent, l'État. Ces écritures
dépendent en plus de qui tient le livre : chez le client, la même facture
devient un achat (607), une dette fournisseur (401) et une TVA déductible
(44566). C'est la thèse de McCarthy (1982) : créances, dettes et ventes se
dérivent des événements.

## Décision

Il n'y a pas de notion « facture » ni de *Materialized Claim* dans
l'ontologie. Une facture est un groupe (*Group*) d'un type configuré
« Facture », qui réunit :

- les événements qu'elle couvre (la livraison du 6 octobre) ;
- l'engagement de paiement qu'elle fixe (8 064 € avant le 6 novembre) et
  l'engagement de TVA envers l'État ;
- un identifiant à séquence sans trou attribué par `ident`
  (`F-2026-0123`).

Un paiement se rapproche de l'engagement de paiement, pas du document. Le
solde dû par un client se calcule : ce qui lui a été livré, moins ce qu'il a
payé.

Les autres pièces se configurent de la même façon. Un avoir réduit un
engagement de paiement. Une pro forma couvre des engagements au lieu
d'événements. Un bon de commande réunit des engagements.

## Conséquences

Aucun code propre aux factures : types de groupe, identifiants et
engagements suffisent, ce qui respecte l'ADR 0002. Les écritures
comptables restent une vue calculée, exportée par un connecteur (ADR 0004).

Il manque une capacité : une facture émise ne se modifie plus, on la corrige
par un avoir. Il faudra pouvoir figer un groupe, c'est-à-dire refuser tout
lien ajouté ou retiré après son émission. Le journal en ajout seul s'y prête.
