# 0001. Une ontologie partagée et des capacités optionnelles

Date : 2026-11-04. Statut : accepté.

## Contexte

Un moteur qui accumule toutes les fonctions finit par devenir trop gros.
C'est ce qui arrive à VoLCA. Modelyz avait choisi l'inverse dès le départ
(parties « RECAP pour ident », « store » et « Scenario
offline ») : chaque capacité technique est un service séparé, branché quand
une solution en a besoin.

Certains usages exigent aussi de travailler hors ligne.

## Décision

**L'ontologie** vit dans la bibliothèque `message`. On y trouve les types
REA, la lecture et l'écriture JSON, et la conversion de chaque message vers
le bon type. C'est elle qui empêche un utilisateur ou un agent IA de faire
n'importe quoi : un message qui ne respecte pas l'ontologie ne peut pas être
construit.

**Chaque capacité est un service optionnel**, client de `store` :

- `store` conserve et orchestre ;
- `ident` attribue les identifiants (numéros de facture, de contrat, de
  devis) ;
- `dumb` est le service par défaut, qui marque comme traités les messages
  qu'aucune autre capacité ne prend en charge ;
- à venir : calcul des soldes, application des règles, connecteurs vers
  l'extérieur (cours de change, comptabilité).

En se connectant, un service annonce son rôle et les messages qu'il traite.
Un message passe de `Requested` à `Processed`, ou à `Error` avec sa raison.

**Chaque interface est autonome.** `studio` et toute interface client ont
leur propre journal et continuent d'enregistrer hors ligne. Elles se
resynchronisent à la reconnexion. C'est à ce moment qu'une facture saisie
hors ligne reçoit son numéro, attribué par `ident`.

**`studio` sert à configurer** et à tester une solution. Ce n'est pas une
interface client finale.

## Conséquences

Une solution client est l'ensemble de sa configuration, des capacités
qu'elle branche et de son interface. Ajouter une capacité ne touche ni
l'ontologie ni les autres services.
