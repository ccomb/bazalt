# 0015. Le sens d'un flux dépend de qui regarde

Date : 2026-11-04. Statut : accepté.

## Contexte

Un ERP classique est tenu du point de vue d'une seule entreprise : la sienne.
Chaque mouvement y est une entrée ou une sortie, chaque échange une vente ou
un achat. Le même fait, vu par le partenaire, doit alors être ressaisi dans
un autre système, dans l'autre sens.

## Décision

Bazalt n'a pas d'agent central « l'entreprise qui possède l'ERP ». Un
événement enregistre l'agent qui fournit et celui qui reçoit (*Participation*),
jamais un sens. « Entrée », « sortie », « vente » ou « achat » sont calculés
au moment de lire, par rapport à l'agent qui regarde.

Exemple : la livraison du lot 42 du fournisseur A au client B est un seul
fait. Pour A, c'est une vente et une sortie de stock. Pour B, c'est un achat
et une entrée. Pour un transporteur, c'est une prestation.

C'est la « vue indépendante » de REA (McCarthy, ISO/IEC 15944-4), plutôt que
la vue d'une entreprise qu'adopte le livre de Hruby.

## Conséquences

Aucun type de `message` ne porte un sens d'entrée ou de sortie. Un champ de
ce genre supposerait une entreprise centrale ; le sens se dérive de
`provider` et `receiver`.

Les mêmes faits valent pour chaque agent qui y participe. Cela ouvre, sans
changer l'ontologie, un extranet pour un partenaire, des faits partagés entre
les ERP de deux entreprises en relation, ou une filière entière décrite dans
un même système. Ces usages restent à décider : ils touchent à l'isolement
des données par client (ADR 0005) et aux droits de chaque agent (ADR 0012).
