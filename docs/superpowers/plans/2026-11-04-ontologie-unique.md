# Une seule définition de l'ontologie : plan de mise en œuvre

> **Pour les agents :** sous-skill requise : superpowers:subagent-driven-development
> (recommandée) ou superpowers:executing-plans, tâche par tâche. Les étapes
> utilisent des cases à cocher (`- [ ]`).

**But :** les types Elm et leurs codecs JSON sont générés depuis les types
Haskell de `message`, et plus jamais écrits à la main.

**Architecture :** un nouveau paquet `gen-elm/` (exécutable
`bazalt-gen-elm`) dépend de `bazalt-message` et de `haskell-to-elm`. Il
déclare, dans des instances orphelines, comment chaque type de `message`
s'écrit en Elm. Il produit `studio/front/generated/Ontology/**.elm`, avec des
codecs calqués sur les `aeson.Options` utilisées côté Haskell. `message` ne
dépend pas de `haskell-to-elm`. Les options JSON sont définies une seule fois,
dans `message/src/Json.hs`, et lues à la fois par les instances Haskell et par
le générateur.

**Pile :** GHC 9.12.4, Elm 0.19.2, `haskell-to-elm` 0.3.2.0, `elm-syntax`
0.3.3.0, `generics-sop`, hspec et QuickCheck pour les tests Haskell, Node pour
le test aller-retour entre les deux langages.

**Spécification :** `docs/adr/0010-ontologie-definie-une-fois.md`, étape 1 de
`docs/feuille-de-route.md`.

## Contraintes globales

- `-Wall` sans avertissement ; fourmolu 0.19.0.1 et hlint 3.5, avec les configs du dépôt ; elm-format.
- Pas de motif joker sur un type somme, pas de fonction partielle, pas d'erreur silencieuse (voir `AGENTS.md`).
- Le code Elm généré n'est jamais modifié à la main. Il est commité, et un contrôle échoue s'il diffère de ce que produit le générateur.
- Seuls les codecs des types primitifs (UUID, instant, rationnel, ensemble) sont écrits à la main, dans `studio/front/src/Ontology/Prim.elm`.
- Pas d'obligation de compatibilité avant la 1.0. Le format JSON change : `IDBVERSION` passe de 49 à 50 dans `studio/front/build.sh`.
- Aucun nom de client dans le code, les tests, la doc ou les commits.
- Ne jamais lancer `git add -A` : ajouter les fichiers un par un. Un sujet par commit.
- Vérifié pendant la préparation : `haskell-to-elm` 0.3.2.0 se compile avec GHC 9.12.4 sans forcer de version. Le code qu'il produit importe `Json.Decode.Pipeline` (paquet Elm `NoRedInk/elm-json-decode-pipeline`). Il encode les types somme avec les clés `tag`/`contents` de `aeson.defaultOptions`, ou avec les options qu'on lui passe.

## Points d'attention en relecture

1. **Journal illisible au démarrage** : un journal dans l'ancien format, ou avec une ligne corrompue, doit arrêter le service avec le numéro de la ligne fautive. Aujourd'hui, `readMessages` renvoie `[]` et le service repart à vide sans rien dire. Test en tâche 2.
2. **Dates** : côté Haskell, `POSIXTime` s'encode en secondes, mais le navigateur envoie des millisecondes, qui sont relues comme des secondes. Un instant créé dans le navigateur doit faire l'aller-retour à la milliseconde près. Test en tâche 5.
3. **Raison d'erreur** : en Haskell, `MessageFlow.Error` porte un `Text`, mais pas en Elm aujourd'hui. Une fois les types générés, la raison doit être affichée dans le studio, et non perdue. Test en tâche 6.
4. **Imbrication profonde** : un `Scope` ou une `Expression` imbriqués sur 50 niveaux doivent se décoder en Elm comme en Haskell. Test en tâche 5.
5. **Étiquette inconnue** : un message dont l'étiquette ne correspond à aucun constructeur (envoyé par un service plus récent, par exemple) doit être signalé dans le studio, et non ignoré. Test en tâche 6.

---

### Tâche 1 : tests aller-retour JSON côté Haskell, qui prouvent le bug de `Scope`

**Fichiers :**
- Modifier : `message/bazalt-message.cabal` (suite de tests : hspec, QuickCheck, quickcheck-instances, generic-arbitrary)
- Remplacer : `message/test/Main.hs`
- Créer : `message/test/Arbitrary.hs` (instances `Arbitrary` orphelines de tous les types de `message`)
- Créer : `message/test/RoundTripSpec.hs`

**Interfaces :**
- Produit : `Arbitrary` pour `Message`, `Payload` et tous leurs champs. Les types récursifs (`Scope`, `Expression`) sont limités en profondeur avec `sized`, et tous les autres passent par `genericArbitrary`. Les instances de `POSIXTime` ne tirent que des instants à la milliseconde près (la résolution du domaine), et celles de `Rational` restent entre −2^53 et 2^53. La tâche 5 réutilise ces instances.

- [ ] **Étape 1 : écrire les tests qui échouent**

```haskell
spec :: Spec
spec = describe "JSON round trip" $ do
    it "Scope And keeps its second operand" $
        decode (encode (And Anything Empty)) `shouldBe` Just (And Anything Empty)
    prop "Scope" $ \(s :: Scope) -> decode (encode s) === Just s
    prop "Expression" $ \(e :: Expression) -> decode (encode e) === Just e
    prop "Payload" $ \(p :: Payload) -> decode (encode p) === Just p
    prop "Message" $ \(m :: Message) -> decode (encode m) === Just m
```

- [ ] **Étape 2 : lancer et constater l'échec**

Commande : `cabal test bazalt-message-test`
Attendu : ÉCHEC sur « Scope And keeps its second operand », avec `key "scope2" not found`.

- [ ] **Étape 3 : commit** (le test rouge documente le bug ; la tâche 3 le corrige)

```bash
git add message/bazalt-message.cabal message/test/Main.hs message/test/Arbitrary.hs message/test/RoundTripSpec.hs
git commit -m "test(message): round-trip every message through JSON"
```

### Tâche 2 : un journal illisible arrête le service

**Fichiers :**
- Modifier : `message/src/Message.hs` (`readMessages`)
- Modifier : les appelants de `readMessages` dans `store/src`, `studio/back/src`, `ident/src` et `dumb/src`
- Test : `message/test/JournalSpec.hs`

**Interfaces :**
- Produit : `readMessages :: FilePath -> IO (Either JournalError [Message])` et `data JournalError = Unreadable FilePath Text | BadLine FilePath Int Text`. Un fichier absent donne `Right []`.

- [ ] **Étape 1 : écrire le test qui échoue**

```haskell
it "stops on the first undecodable line, naming it" $ do
    -- fichier temporaire : une ligne valide, puis "{not json}"
    r <- readMessages path
    r `shouldSatisfy` \case Left (BadLine _ 2 _) -> True; _ -> False
```

- [ ] **Étape 2 : lancer et constater l'échec** (ne compile pas : `readMessages` renvoie encore `IO [Message]`)
- [ ] **Étape 3 : implémenter.** Chaque service affiche l'erreur sur stderr et quitte avec un code non nul.
- [ ] **Étape 4 : lancer les tests** : `cabal test bazalt-message-test --test-options='-m Journal'` ; attendu : SUCCÈS. Puis `cabal build all` ; attendu : sans avertissement.
- [ ] **Étape 5 : commit**

```bash
git add message/src/Message.hs message/test/JournalSpec.hs message/bazalt-message.cabal store/src/Main.hs studio/back/src/Main.hs ident/src/Main.hs dumb/src/Main.hs
git commit -m "fix: stop a service whose journal has an unreadable line"
```

### Tâche 3 : options JSON uniques et instances génériques

**Fichiers :**
- Créer : `message/src/Json.hs`
- Modifier : chaque module de `message/src` qui déclare `FromJSON`/`ToJSON`, et `message/bazalt-message.cabal` (module `Json` exposé)

**Interfaces :**
- Produit : `Json.taggedOptions`, `Json.payloadOptions` et `Json.enumOptions`, toutes de type `Data.Aeson.Options`. Leurs valeurs sont celles d'aujourd'hui : `TaggedObject "type" "value"`, `TaggedObject "what" "load"` et `UntaggedValue`. La tâche 4 les passe au générateur.
- Produit : `data Message = Message { meta :: Metadata, load :: Payload }`, encodé en `{"meta":…,"load":…}`, comme aujourd'hui.

- [ ] **Étape 1 : implémenter.** Toutes les instances deviennent `genericParseJSON`/`genericToJSON` avec l'une des trois options de `Json.hs`. Les instances écrites à la main (`Scope`, `Type`, `Message`, la double imbrication `value.value` de `Identified`) disparaissent, et la clé fautive `"scpe1"` avec elles.
- [ ] **Étape 2 : lancer tous les tests** : `cabal test bazalt-message-test` ; attendu : SUCCÈS, y compris le test rouge de la tâche 1. Puis `cabal build all` ; attendu : sans avertissement.
- [ ] **Étape 3 : commit**

```bash
git add message/src message/bazalt-message.cabal
git commit -m "fix(message): derive every JSON codec from one set of options"
```

### Tâche 4 : le générateur `bazalt-gen-elm`

**Fichiers :**
- Créer : `gen-elm/bazalt-gen-elm.cabal`, `gen-elm/src/Ontology/Elm.hs` (instances orphelines, `{-# OPTIONS_GHC -Wno-orphans #-}`), `gen-elm/app/Main.hs`
- Modifier : `cabal.project` (ajouter `gen-elm`)
- Créer : `studio/front/src/Ontology/Prim.elm` (codecs primitifs écrits à la main)
- Modifier : `studio/front/elm.json` (ajouter `"generated"` aux sources, et la dépendance `NoRedInk/elm-json-decode-pipeline`)
- Créer : `studio/front/generated/Ontology/**.elm` (produit par l'outil, puis commité)
- Créer : `gen-elm/check.sh`

**Interfaces :**
- Consomme : les trois options de `Json.hs` (tâche 3).
- Produit : un module Elm `Ontology.<Module Haskell>` par module de `message`. Par exemple, `Ontology.Event.Event` expose `Event`, `encoder` et `decoder`. La tâche 6 importe ces noms.
- Produit : dans `Ontology.Prim`, `uuidEncoder`/`uuidDecoder` (qui délèguent à `Prng.Uuid`), `posixEncoder`/`posixDecoder` (les secondes de `aeson`, en nombre décimal, converties vers et depuis `Time.Posix`), `rationalEncoder`/`rationalDecoder` (`{"numerator","denominator"}`, avec un décodeur qui échoue explicitement hors de ±2^53 au lieu d'arrondir) et `setEncoder`/`setDecoder` (une liste JSON). Les instances `HasElmType` de `UUID`, `POSIXTime`, `Rational` et `Set a` pointent vers ces noms.
- Produit : la commande `cabal run bazalt-gen-elm -- studio/front/generated`, qui écrit les fichiers puis lance `elm-format --yes` dessus.

- [ ] **Étape 1 : écrire `gen-elm/check.sh`** : il génère dans un dossier temporaire et le compare (`diff -r`) à `studio/front/generated`. Il échoue s'ils diffèrent, puis lance `elm make src/Main.elm --output=/dev/null` dans `studio/front`.
- [ ] **Étape 2 : lancer `gen-elm/check.sh`** ; attendu : ÉCHEC, car le générateur n'existe pas encore.
- [ ] **Étape 3 : implémenter.** Pour chaque type, dérivez `SOP.Generic` et `SOP.HasDatatypeInfo` par `deriving anyclass instance` autonome. Écrivez ensuite les trois instances `HasElmType`, `HasElmDecoder Aeson.Value` et `HasElmEncoder Aeson.Value`, avec les `aeson.Options` de ce type. `Main` rassemble `jsonDefinitions @T` pour chaque type, puis écrit `Language.Elm.Pretty.modules`.
- [ ] **Étape 4 : générer, puis relancer `gen-elm/check.sh`** ; attendu : `diff` est vide. `elm make` peut encore échouer à cette étape, car le front n'utilise pas encore les modules générés : c'est l'objet de la tâche 6. Pour que l'étape ait un critère vérifiable, `check.sh` compile aussi `generated/Ontology/Payload.elm` et `generated/Ontology/Message.elm` seuls, et ces compilations doivent passer.
- [ ] **Étape 5 : commit**

```bash
git add cabal.project gen-elm/ studio/front/elm.json studio/front/src/Ontology/Prim.elm studio/front/generated/
git commit -m "feat: generate the Elm ontology from the Haskell message types"
```

### Tâche 5 : test aller-retour entre Haskell et Elm

**Fichiers :**
- Créer : `gen-elm/app/Fixtures.hs` (exécutable `bazalt-fixtures` : `N` messages tirés par QuickCheck avec une graine fixe, une ligne JSON chacun, plus des cas fixes)
- Créer : `studio/front/tests/RoundTrip.elm` (`Platform.worker` : reçoit une ligne par un port, la décode avec `Ontology.Message.decoder`, la réencode, et renvoie le résultat ou l'erreur)
- Créer : `studio/front/tests/roundtrip.mjs`, `gen-elm/roundtrip.sh`
- Créer : `message/test/CrossSpec.hs` (relit la sortie d'Elm et la compare à l'entrée)

**Interfaces :**
- Consomme : les instances `Arbitrary` (tâche 1) et les modules générés (tâche 4).

- [ ] **Étape 1 : écrire les cas fixes dans `Fixtures.hs`**, en plus des messages tirés au hasard : un `Scope` imbriqué sur 50 niveaux de `And`, une `Expression` imbriquée sur 50 niveaux, un `Metadata` avec `when` = `1695927356.951`, un `MessageFlow` `Error "raison"`, et un `Payload` pour chacun de ses constructeurs.
- [ ] **Étape 2 : écrire `roundtrip.sh`.** Il fait trois choses : `cabal run bazalt-fixtures > in.jsonl`, puis `node roundtrip.mjs < in.jsonl > out.jsonl` (le script Node compile le worker avec `elm make`), puis `cabal test bazalt-message-test --test-options='-m Cross'`. `CrossSpec` vérifie que chaque ligne de `out.jsonl` se décode côté Haskell et donne la même valeur que la ligne correspondante de `in.jsonl`, et qu'aucune ligne n'est une erreur.
- [ ] **Étape 3 : lancer `gen-elm/roundtrip.sh`** ; attendu : SUCCÈS. En cas d'échec, corriger le codec primitif concerné dans `Ontology/Prim.elm` ou l'instance concernée dans `Ontology/Elm.hs`, jamais le code généré.
- [ ] **Étape 4 : commit**

```bash
git add gen-elm/app/Fixtures.hs gen-elm/bazalt-gen-elm.cabal gen-elm/roundtrip.sh studio/front/tests/RoundTrip.elm studio/front/tests/roundtrip.mjs message/test/CrossSpec.hs message/bazalt-message.cabal
git commit -m "test: prove every message survives a Haskell to Elm round trip"
```

### Tâche 6 : le front Elm passe aux types générés

**Fichiers :**
- Modifier : les modules Elm qui déclarent `encode`/`decoder` pour un type de `message` (pour les retrouver : `grep -rl -E '^(encode|decoder) :' studio/front/src`). Si un module ne contient que le type et ses codecs, le supprimer et faire pointer ses imports vers `Ontology.*`. S'il contient aussi des fonctions utiles, garder ces fonctions et importer le type depuis `Ontology.*`.
- Modifier : les pages qui lisent des champs disparus. Ces pages suivent désormais le modèle Haskell, qui fait référence (ADR 0010) : `Event.resource` devient `Event.flow` et `Event.qty` ; `Resource` reçoit `qty` ; `HardLink.EventResource` devient `EventInflow`/`EventOutflow`.
- Modifier : `studio/front/src/Shared.elm` (afficher la raison d'un `Error` et un échec de décodage)
- Modifier : `studio/front/build.sh` (`IDBVERSION=50`, et lancer `gen-elm/check.sh` avant la compilation)
- Supprimer : le code mort qui ne compile pas, `studio/front/src/Conversion.elm` et `studio/front/src/Conversion/` (ADR 0001 : la conversion sera reprise à l'étape 3 de la feuille de route)

- [ ] **Étape 1 : écrire le test e2e qui échoue** dans `studio/test/playwright/tests/ontology.spec.ts`. Il démarre les services (`store`, `ident`, `dumb`, `studio`) sur un journal vide, crée un type d'événement puis un événement depuis le studio, et vérifie que `store/data/messagestore.txt` contient une ligne `"flow":"Processed"` pour cet événement. Un second cas injecte dans le WebSocket un message à l'étiquette inconnue, puis un message en `Error "raison"`, et vérifie que le studio affiche les deux.
- [ ] **Étape 2 : le lancer** ; attendu : ÉCHEC (l'événement ne se décode pas côté Haskell, ou le front ne compile pas).
- [ ] **Étape 3 : migrer les modules**, en suivant les erreurs du compilateur Elm jusqu'à ce que `elm make src/Main.elm` passe. Lancer ensuite `studio/front/review.sh`.
- [ ] **Étape 4 : relancer le test e2e et `gen-elm/roundtrip.sh`** ; attendu : SUCCÈS pour les deux.
- [ ] **Étape 5 : commit**

```bash
git add studio/front/src studio/front/build.sh studio/test/playwright/tests/ontology.spec.ts
git commit -m "refactor(studio): use the generated ontology instead of hand-written codecs"
```

### Tâche 7 : documentation

**Fichiers :**
- Modifier : `AGENTS.md`. Le paragraphe « Invariant to protect » est remplacé par la règle suivante : l'ontologie se modifie dans `message`, on relance `cabal run bazalt-gen-elm -- studio/front/generated`, on ne touche jamais `generated/`, et `IDBVERSION` change quand le JSON change. La partie « Commands » reçoit `gen-elm/check.sh` et `gen-elm/roundtrip.sh`.
- Modifier : `docs/adr/0010-ontologie-definie-une-fois.md` (outil retenu : `haskell-to-elm` 0.3.2.0, et pourquoi : il reproduit les `aeson.Options`, alors que `elm-street` impose son propre format)
- Modifier : `docs/feuille-de-route.md` (étape 1 cochée)

- [ ] **Étape 1 : modifier les trois fichiers, puis relire `AGENTS.md` et `README.md`** pour y chercher toute phrase contredite par le nouveau code (règle « Documentation » de `AGENTS.md`).
- [ ] **Étape 2 : commit**

```bash
git add AGENTS.md docs/adr/0010-ontologie-definie-une-fois.md docs/feuille-de-route.md
git commit -m "docs: explain how the Elm ontology is generated"
```
