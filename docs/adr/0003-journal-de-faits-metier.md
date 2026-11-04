# 0003. Le journal enregistre des faits métier validés

Date : 2026-11-04. Statut : accepté.

## Contexte

Le journal actuel enregistre des modifications de données (`AddedEvent`,
`ChangedResource`, `RemovedCommitment`). Rien n'empêche d'y écrire un état
incohérent, par exemple un paiement qui honore un engagement inexistant.
Les interfaces doivent pourtant pouvoir écrire hors ligne
([ADR 0001](0001-ontologie-et-capacites.md)).

## Décision

Le journal enregistre des faits métier : « engagement pris », « événement
réalisé, qui honore tel engagement », « réservation levée ». La validation
se fait sur deux étages.

1. **Dans les types de `message`** : tout ce qui ne dépend que du message
   lui-même. Une quantité est toujours rapportée à un type de ressource, un
   événement a toujours un fournisseur et un receveur. Un message qui viole
   ces règles ne peut pas être construit, même hors ligne.
2. **Par une capacité, à la synchronisation** : tout ce qui dépend du reste
   du journal. L'engagement honoré existe-t-il ? Le stock est-il déjà
   réservé ? Le type est-il clos ?

Un fait refusé revient en `Error` avec sa raison, affichée à l'utilisateur.
Rien n'est refusé en silence. Entre deux saisies hors ligne en conflit, la
première arrivée à `store` l'emporte.

## Conséquences

La correction d'une erreur est elle-même un fait (annulation,
contre-passation), jamais une réécriture.
