# Glossaire

Les termes REA restent en anglais, comme dans le livre de Hruby (*Model-Driven
Design Using Business Patterns*) et dans le code. Chaque terme donne son
équivalent français, sa définition, un exemple inventé, pris chez un importateur de fruits ou dans une
association d'adhérents, et son état dans le moteur.

Les numéros de page renvoient au livre imprimé.

## Niveau opérationnel : ce qui s'est passé

**Economic Resource** (ressource économique). Chose rare, utile, que
l'entreprise veut planifier, suivre et contrôler. Importateur : un lot de purée de
mangue, des euros, des dollars. Association : l'argent des cotisations. Page 19.
État : partiel.

**Economic Event** (événement économique). Augmentation ou diminution d'une
ressource que l'entreprise contrôle. Importateur : réception d'un conteneur, paiement
d'une facture fournisseur. Association : encaissement d'un chèque. Page 23.
État : partiel.

**Economic Agent** (agent économique). Personne ou organisation qui peut
contrôler des ressources et en céder ou en recevoir le contrôle. Importateur : un
producteur indien, un embouteilleur client. Association : un adhérent. Page 33.
État : fait.

**Participation** (provide / receive). Un événement a toujours un agent qui
fournit et un agent qui reçoit. État : fait.

**Stockflow** (inflow / outflow). Lien entre un événement et la ressource
qu'il augmente (inflow) ou diminue (outflow). Page 21. Le sens n'est pas
enregistré : il se déduit du fournisseur et du receveur, pour l'agent qui
regarde (ADR 0015). État : partiel, seul un flux par événement.

**Exchange** (échange). Processus où l'entreprise donne des ressources contre
d'autres. Importateur : vendre de la purée contre des dollars. Page 15. État : absent.

**Conversion**. Processus qui consomme ou utilise des ressources pour en
produire d'autres. Importateur : transformation de fruits frais par un sous-traitant.
Page 41. État : absent.

**Duality** (dualité). Lien qui équilibre ce qui sort et ce qui entre dans un
échange ou une conversion. Sans dualité, pas de marge calculable. Pages 28 et
54. État : absent.

**Value Chain** (chaîne de valeur). Enchaînement des échanges et conversions
par les ressources qu'ils se transmettent. Page 65. État : absent.

## Niveau des engagements et des règles : ce qui doit ou peut se passer

**Type**. Description d'une famille homogène d'entités (ressources,
événements, agents…). Défini par configuration, jamais dans le code. Importateur :
« purée de mangue alphonso », « client embouteilleur ». Page 88. État : fait,
avec hiérarchie.

**Group** (groupe). Collection hétérogène d'entités, définie par un
**Scope** (algèbre d'ensembles sur types, groupes et identifiants). Association :
une section syndicale. Page 84. État : fait.

**Commitment** (engagement). Promesse d'un événement économique futur. Importateur :
le volume annoncé par un client pour la prochaine récolte. Page 93. État :
partiel, sans lien vers l'événement qui l'honore.

**Fulfillment** (réalisation). Lien entre un engagement et l'événement qui
l'honore, en tout ou en partie. État : absent.

**Reservation** (réservation). Ressource mise de côté pour un engagement. Importateur :
le stock réservé « sur le bateau » pour un client qui n'a pas confirmé.
État : absent.

**Contract** (contrat). Ensemble d'engagements réciproques et de clauses qui
peuvent créer d'autres engagements (pénalités). Importateur : contrat annuel avec un
embouteilleur, avec incoterm. Page 101. État : coquille vide.

**Schedule** (planification). Engagements de conversion futurs. Page 108.
État : absent.

**Policy** (règle). Règle métier qui interdit ou signale un événement. Importateur :
alerte quand un client consomme plus que son volume annoncé. Page 112. État :
absent.

**Linkage** (composition). Structure des ressources, par exemple une
nomenclature. Page 119. État : absent.

**Responsibility** (responsabilité). Structure entre agents. Association : un
responsable de section. Page 122. État : absent.

**Custody** (garde). Agent responsable de ressources précises. Importateur : le
transitaire qui détient un conteneur. Page 125. État : absent.

## Patrons de comportement

**Identification** (identifiant). Identité des choses représentées, par
fragments (libre, fixe, séquence, date). Association : le numéro d'un adhérent.
Page 159. État : fait.

**Classification**. Hiérarchie de catégories. Page 166. État : couvert par
Type et Group, à confirmer.

**Location** (lieu). Où se passe un événement. Importateur : port de départ au Pérou.
Page 174. État : absent.

**Posting** (historique). Historique des interactions entre agents. Page 180.
État : le journal le donne, sans vue dédiée.

**Account** (compte). Solde courant calculé à partir des augmentations et des
diminutions. Importateur : stock disponible, compte en dollars. Page 186. État : absent.

**Materialized Claim** (créance matérialisée). Déséquilibre d'un échange
rendu visible, comme une facture. Association : la cotisation due. Page 194.
État : écarté. Le solde dû se calcule, et une facture est un groupe
identifié d'événements et d'engagements
([ADR 0016](adr/0016-facture-groupe-identifie.md)).

**Reconciliation** (lettrage). Rapprochement des événements qui
s'équilibrent. Association : affecter un paiement à une adhésion. Page 201. État :
le mot existe dans le code pour affecter un événement à un processus, le
patron du livre est absent.

**Due Date** (échéance). Dates dues et leur suivi. Importateur : l'échéancier de
trésorerie. Page 207. État : absent.

**Value** (valeur). Information quantitative calculée par une
**Expression** (formule). Association : cotisation = indice × coefficient × taux.
Page 226. État : fait dans le front Elm seulement, sans unité.

**Equivalence** (équivalence). Lien entre deux types de ressources, qui se
compose avec les autres (une catégorie). Trois natures : fixe et physique
(1 tonne de patate = 1000 kg de patate), datée et observée (cours euro/dollar
du jour), convenue (prix de catalogue). Le prix réellement convenu d'une vente
n'est pas une équivalence : il vient de l'engagement honoré. Ne pas confondre
avec Conversion, qui est un processus. Voir
[ADR 0008](adr/0008-devise-type-de-ressource.md). État : absent.

**Description**, **Note**. Information libre attachée à une entité. Pages
213 et 222. État : absent.

**Notification**. Prévenir les utilisateurs d'un changement. Page 217. État :
absent.

## Termes propres à Bazalt

**Configuration**. Ensemble des types, identifiants, valeurs, groupes et
règles qui décrivent un client. Tout le vocabulaire du client vit là, jamais
dans le code. Voir [ADR 0002](adr/0002-configuration-seule.md).

**Fait métier**. Entrée du journal validée par l'ontologie et les capacités : « engagement
pris », « événement réalisé », « réservation levée ». Voir
[ADR 0003](adr/0003-journal-de-faits-metier.md).
