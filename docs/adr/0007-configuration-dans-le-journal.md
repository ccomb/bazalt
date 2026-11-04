# 0007. La configuration vit dans le journal

Date : 2026-11-03. Statut : accepté.

## Contexte

On aurait pu décrire chaque client dans un fichier déclaratif versionné dans
git. Mais un journal de faits de configuration est presque aussi lisible
qu'un fichier déclaratif. Il permet aussi de changer la configuration
pendant que le système tourne, et il applique un principe unique à tout.

## Décision

La configuration est une suite de faits de configuration (« type de
ressource défini », « identifiant ajouté à tel type »), écrits dans un
journal comme les faits métier et validés de la même façon par le moteur.

Le journal suit les règles de celui de VoLCA (`Database/Journal.hs`) :

- chaque ligne enregistre une action, pas un résultat, et la relecture
  redérive tout le reste ;
- chaque ligne porte une version de format ;
- la relecture s'arrête, au lieu de continuer en silence, si un identifiant
  recalculé diffère de celui qui a été écrit ;
- une dernière ligne tronquée a une règle explicite.

Il n'y a qu'un journal : faits de configuration et faits métier s'y suivent
dans l'ordre d'arrivée. Chaque fait métier est validé contre la
configuration en vigueur au moment où il est écrit, et le système se
reconstitue tel qu'il était à n'importe quelle date.

Un type déjà utilisé n'est jamais supprimé ni rendu incompatible : on peut
seulement le clore (plus de nouveaux faits) ou lui ajouter un champ
facultatif. Toute autre modification est refusée avec sa raison.

La configuration d'un client réel n'est jamais committée dans ce dépôt,
seulement dans le dépôt propre à ce client.

## Conséquences

Voir [ADR 0009](0009-tests-par-cas-inventes.md) pour les tests.
