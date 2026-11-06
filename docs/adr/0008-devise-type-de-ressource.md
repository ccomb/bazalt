# 0008. Une devise est un type de ressource, pas une unité

Date : 2026-11-03. Statut : accepté.

## Contexte

Presque tous les logiciels traitent « € » comme une unité, au même titre
que « kg ». C'est une erreur : des euros et des kilos n'ont rien en commun.
Les notes de conception de Modelyz arrivent progressivement à cette conclusion.

## Décision

Une quantité est un nombre nu, toujours rapporté à un type de ressource.
« 1 kg de patate » se lit comme la quantité 1 du type de ressource « kg de
patate ». « 100 € » se lit comme la quantité 100 du type de ressource
« euro ». Le moteur n'a pas de système d'unités séparé.

Le passage d'un type de ressource à un autre (tonne et kg de patate, euro
et dollar, litre et kg de plomb) est un lien entre deux types de ressources.
Ces liens se composent, ce qui en fait une catégorie.

## Conséquences

Additionner des quantités de deux types différents est refusé, sauf s'il
existe un lien entre eux. Le change euro/dollar est un échange REA entre
deux ressources, et son résultat sort de la dualité.
