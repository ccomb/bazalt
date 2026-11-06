# 0004. La comptabilité générale reste hors du moteur

Date : 2026-11-03. Statut : accepté.

## Contexte

REA permet en théorie de dériver les écritures comptables des événements.
Un client tient en général sa comptabilité dans un outil dédié, avec son
cabinet comptable, et ne veut pas en changer.

## Décision

Bazalt sert à la gestion et au pilotage : engagements, stocks, marges,
trésorerie prévisionnelle, traçabilité. Le grand livre légal reste dans
l'outil comptable du client. Le lien passe par un connecteur, hors du
moteur.

## Conséquences

Le moteur ne contient aucun nom d'outil comptable. Il expose ce qu'il faut
pour qu'un connecteur exporte les factures et importe les paiements.
