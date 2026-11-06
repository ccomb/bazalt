# 0005. Une instance par client

Date : 2026-11-03. Statut : accepté.

## Décision

Chaque client a son propre processus et son propre journal. Le moteur ne
gère pas plusieurs clients dans un même stockage.

## Raison

C'est le plus simple. Les données de chaque client sont isolées par
construction, et cela colle au stockage en fichiers append-only.
