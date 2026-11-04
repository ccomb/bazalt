# 0011. Une passerelle pour l'API, MCP et la ligne de commande

Date : 2026-11-04. Statut : accepté.

## Décision

Un service passerelle, client de `store` comme `studio/back`, expose une API
HTTP et un serveur MCP, dérivés d'un registre unique d'opérations comme dans
VoLCA (`API.Resources`). Une ligne de commande, ou un REPL, passe par la même
passerelle et permet de saisir une configuration pas à pas.

## Conséquences

Un agent IA et un humain au clavier passent par le même chemin, et chacun
de leurs messages est validé par l'ontologie.
