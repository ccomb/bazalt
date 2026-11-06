# 0006. La couverture REA se prouve par des cas concrets

Date : 2026-11-03. Statut : accepté.

## Décision

La liste de contrôle est celle des patrons du livre de Hruby : ceux du
chapitre 2 (Group, Type, Commitment, Contract, Schedule, Policy, Linkage,
Responsibility, Custody) et ceux du chapitre 5 (Identification,
Classification, Location, Posting, Account, Materialized Claim,
Reconciliation, Due Date, Description, Notification, Note, Value). Voir le
[glossaire](../glossary.md).

Chaque patron est validé par au moins un cas concret, écrit en pure
configuration :

- des cas inventés, inspirés des chapitres 7 à 10 du livre (vente au
  comptant, prêt, bon de commande, transport, pénalité…) ;
- des cas inventés, inspirés des premiers clients réels, qui fixent l'ordre
  de priorité. Par exemple, l'échéancier d'un importateur de fruits passe
  d'abord par Commitment, Contract, Due Date, Materialized Claim et
  Reservation.

Le moteur est complet quand il représente tous ces cas sans code spécifique
à un client.

Chaque notion REA, même celles dont les premiers clients n'ont pas besoin, reçoit un cas d'usage réel ou imaginé, décrit en langage métier
avant d'être modélisé. Une notion sans cas d'usage crédible n'entre pas dans
l'ontologie.
