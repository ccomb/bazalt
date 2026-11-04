# Du vocabulaire métier aux notions REA

Ce glossaire est réutilisable d'un client à l'autre. Il rattache un mot du
métier à une notion REA (voir le [glossaire REA](glossary.md)). La skill qui
traduit un cahier des charges en configuration le consulte, et elle
l'enrichit à chaque client. Un mot qu'elle ne sait pas rattacher signale un
manque possible de l'ontologie : on le note dans la dernière partie, et on
ne le contourne jamais par un cas particulier.

Les rattachements marqués « à confirmer » n'ont pas encore été éprouvés par
un cas.

## Rattachements

| Mot du métier | Notion REA | Remarque |
|---|---|---|
| client, fournisseur, producteur, transitaire | Economic Agent | le rôle est un Type ou un Group d'agents |
| adhérent | Economic Agent dans un Group | association |
| prospect, lead | Economic Agent dans un Group « prospect » | à confirmer |
| opportunité commerciale | Contract à l'état de brouillon | à confirmer |
| devise (euro, dollar) | Resource Type | jamais une unité ([ADR 0008](adr/0008-devise-type-de-ressource.md)) |
| kg de purée de mangue | Resource Type | « 1 kg de patate » = 1 × type « kg de patate » |
| taux de change, prix de catalogue | Equivalence | datée et observée pour le change, convenue pour le catalogue |
| prix convenu d'une vente | quantité d'un Commitment du Contract | jamais stocké dans l'événement |
| bon de commande, contrat annuel | Contract | |
| volume annoncé par un client | Commitment | |
| stock réservé | Reservation | |
| livraison, réception | Economic Event (outflow, inflow) | |
| paiement, encaissement | Economic Event | |
| facture, cotisation due | Materialized Claim | |
| lettrage | Reconciliation | |
| échéancier de trésorerie | vue sur Commitment et Due Date, par devise | calculée par une capacité ([ADR 0014](adr/0014-donnees-exterieures-et-vues.md)) |
| incoterm | clause du Contract, avec Location et Custody | à confirmer |
| transformation par un sous-traitant | Conversion | |
| barème, indice, taux | Value et Expression | association |
| numéro de facture, numéro d’adhérent | Identification | attribué par `ident` |
| statut, grade, échelon | Group, avec Classification | association |
| responsable de section | Responsibility | association |

## Mots pas encore rattachés

| Mot du métier | Piste |
|---|---|
| certification d'un fournisseur | observation datée sur l'agent, contrôlée par une Policy ? |
| analyse de laboratoire d'un lot | observation datée sur la ressource ? |
| marge par typologie de client et de produit | vue sur la dualité, par Group ? |
