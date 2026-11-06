# 0013. Les contrats sont composés de briques

Date : 2026-11-04. Statut : accepté.

## Contexte

Les notes de conception de Modelyz envisagent
les contrats composables de Peyton Jones : un contrat est une combinaison de
briques qui produit des engagements selon la date et les observations.

## Décision

Le langage de règles comprend un petit jeu de briques de contrat (« à telle
date », « si telle observation », « donner », « recevoir »), juste assez
pour exprimer des conditions de paiement (« 40 % à la commande, 60 % à
60 jours après l'arrivée au port »), des volumes annoncés et des pénalités.
Ce langage est pur, total et vérifié au chargement : additionner des euros
et des kilos de mangue y est refusé.

On ajoute une brique quand un cas d'usage l'exige.
