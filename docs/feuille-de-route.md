# Feuille de route

Chaque étape est utilisable seule.

1. (Fait.) Une seule définition de l'ontologie : types Elm générés depuis `message`
   ([ADR 0010](adr/0010-ontologie-definie-une-fois.md)), et correction de la
   clé JSON fautive de `Scope` (`"scpe1"` écrit à la place de `"scope2"`).
2. Le service passerelle, avec MCP et une ligne de commande
   ([ADR 0011](adr/0011-passerelle-api-mcp-cli.md)).
3. Les notions REA manquantes dans `message` : dualité, réalisation,
   réservation, créance, équivalence, contrat. Chacune arrive avec un cas
   d'usage réel ou imaginé ([ADR 0006](adr/0006-couverture-rea-par-les-cas.md))
   et un test ([ADR 0009](adr/0009-tests-par-cas-inventes.md)).
4. La capacité de calcul des soldes
   ([ADR 0014](adr/0014-donnees-exterieures-et-vues.md)).
5. La skill « cahier des charges vers configuration », appliquée à un cahier
   des charges inventé d'importateur de fruits. Elle s'appuie sur le
   [glossaire métier vers REA](metier-vers-rea.md) et l'enrichit.

Hors sujet pour l'instant : la montée en charge (plusieurs instances d'un même
service, répartition du travail entre elles).
