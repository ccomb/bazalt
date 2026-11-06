# 0002. Aucun vocabulaire client dans le code

Date : 2026-11-03. Statut : accepté.

## Contexte

C'est l'idée fondatrice de Modelyz. Plusieurs notions d'un syndicat
(adhérent, numéro d'adhérent, indice, taux) ont déjà été modélisées en pure configuration dans le
studio, sans une ligne de code spécifique. Avec les agents IA, cette idée
devient concrète : un agent peut traduire un cahier des charges d'ERP en
configuration, et le système obtenu est utilisable tout de suite.

## Décision

Le code ne contient que les notions REA. Tout concept et tout mot propre à
un client (« adhérent », « purée de mangue », « incoterm FOB ») vit dans la
configuration : types, identifiants, valeurs, groupes, règles.

Un client étend son outil à deux niveaux seulement : en ajoutant de la
configuration au moteur, ou en construisant une interface qui passe par
l'API. Aucune extension n'écrit directement dans le stockage.

## Conséquences

Si un besoin client ne s'exprime pas en configuration, c'est un manque du
moteur REA. On le comble par une notion REA générale, jamais par un cas
particulier.
