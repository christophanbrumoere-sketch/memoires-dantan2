# Modele de donnees initial

Projet : outil d'archivage genealogique, clanique et coutumier en Nouvelle-Caledonie.

Ce document pose une premiere structure de donnees. Il n'est pas encore une base de donnees definitive : c'est notre plan de travail pour verifier que l'outil pourra conserver les personnes, les clans, les evenements coutumiers, les terres, les sources et les relations sans reduire la complexite de la transmission orale.

## 1. Idee centrale

L'outil ne doit pas etre pense comme un simple arbre genealogique.

Il doit permettre de repondre a quatre questions :

1. Qui est cette personne ?
2. A qui est-elle liee genealogiquement, clanquement et coutumierement ?
3. Quelle histoire explique son nom, son clan, ses droits ou ses obligations ?
4. Qui a transmis cette information, avec quel niveau de confiance et de confidentialite ?

## 2. Objets principaux

| Objet | Role | Exemple |
|---|---|---|
| Personne | Individu archive dans l'outil | Une personne avec plusieurs prenoms, un nom actuel, un nom de naissance, un clan actuel |
| Clan | Groupe d'appartenance, d'alliance, de hierarchie et de transmission | Clan paternel, clan maternel, clan allie, clan recevant un enfant redonne aux oncles maternels |
| Relation | Lien entre deux personnes, deux clans, ou une personne et un clan | Pere, mere, conjoint, oncle maternel, clan allie, appartenance |
| Evenement coutumier | Fait de vie ou acte coutumier documente | Naissance, souffle des oncles maternels, mariage, deces, enfant redonne aux oncles maternels |
| Terre coutumiere | Lieu, terre ou droit rattache a un clan, une lignee ou une personne | Terre associee a un clan, droit d'usage, droit conteste |
| Source | Origine d'une information | Ancien, temoignage oral, reunion familiale, document, audio |
| Piece jointe | Fichier conserve avec une fiche ou une source | Photo, scan, audio, note manuscrite |

## 3. Fiche Personne

Une personne doit pouvoir porter plusieurs identites dans le temps.

### Champs principaux

| Champ | Type | Remarque |
|---|---|---|
| id | Identifiant interne | Cree automatiquement |
| prenoms | Liste de textes | Plusieurs prenoms possibles |
| nom_actuel | Texte | Nom utilise actuellement ou au dernier etat connu |
| nom_naissance | Texte | Si connu |
| autres_noms | Liste de textes | Anciens noms, surnoms, noms coutumiers |
| sexe | Choix | A definir avec prudence : homme, femme, inconnu, autre si necessaire |
| date_naissance | Date ou periode | Peut etre exacte, approximative ou inconnue |
| lieu_naissance | Texte ou lieu structure | Village, commune, aire, autre |
| date_deces | Date ou periode | Optionnel |
| lieu_deces | Texte ou lieu structure | Optionnel |
| notes_biographiques | Texte long | Notes libres |
| confidentialite | Niveau | Public, familial, sensible, reserve |

### Identite dans le temps

Comme un nom ou une appartenance peut changer, il faut eviter de tout ecraser dans la fiche principale.

On prevoit donc une table d'historique :

| Champ | Description |
|---|---|
| personne_id | Personne concernee |
| type_changement | Nom, clan, famille, droits, autre |
| ancienne_valeur | Valeur avant changement |
| nouvelle_valeur | Valeur apres changement |
| date_effet | Date ou periode du changement |
| evenement_id | Evenement qui explique le changement |
| source_id | Source de l'information |
| commentaire | Details libres |

## 4. Fiche Clan

Le clan n'est pas seulement une etiquette. Il porte des appartenances, des relations, des alliances, une place dans une hierarchie et parfois des terres.

### Champs principaux

| Champ | Type | Remarque |
|---|---|---|
| id | Identifiant interne | Cree automatiquement |
| nom | Texte | Nom principal du clan |
| variantes_nom | Liste de textes | Orthographes ou appellations differentes |
| aire_coutumiere | Texte | Si utile |
| commune_ou_region | Texte | Localisation large |
| description | Texte long | Histoire, role, notes |
| clan_parent_id | Lien vers Clan | Pour une hierarchie simple si elle existe |
| rang_ou_role | Texte | Grand clan, clan allie, clan sujet, autre vocabulaire a definir |
| confidentialite | Niveau | Certains clans ou informations peuvent etre sensibles |

### Relations entre clans

| Type de relation | Description |
|---|---|
| alliance | Clan allie a un autre clan |
| hierarchie | Clan place au-dessus, au-dessous ou dans une relation de responsabilite |
| origine | Clan d'origine d'une branche ou d'une personne |
| maternel | Clan maternel lie a une personne ou une lignee |
| reception_enfant_redonne | Clan qui recoit un enfant redonne aux oncles maternels |
| conflit_ou_contestation | Relation sensible a documenter avec prudence |

Chaque relation entre clans doit avoir :

| Champ | Description |
|---|---|
| clan_a_id | Premier clan |
| clan_b_id | Second clan |
| type_relation | Alliance, hierarchie, origine, autre |
| sens_relation | Sens unique ou reciproque |
| date_debut | Si connue |
| date_fin | Si la relation a pris fin ou a change |
| source_id | Source de l'information |
| niveau_certitude | A verifier, probable, confirme, conteste |
| confidentialite | Niveau d'acces |
| commentaire | Recit ou explication |

## 5. Relations de personne

Les relations ne doivent pas se limiter a pere/mere/enfant.

| Relation | Entre | Remarque |
|---|---|---|
| pere | Personne -> Personne | Filiation paternelle |
| mere | Personne -> Personne | Filiation maternelle |
| enfant | Personne -> Personne | Peut etre deduit de pere/mere mais utile en affichage |
| conjoint | Personne -> Personne | Mariage civil, coutumier ou union a qualifier |
| frere_soeur | Personne -> Personne | Peut etre deduit mais parfois utile |
| oncle_maternel | Personne -> Personne | Important pour souffle, enfant redonne aux oncles maternels et liens coutumiers |
| tante_maternelle | Personne -> Personne | A prevoir si pertinent |
| parent_coutumier | Personne -> Personne | Cas d'adoption, enfant redonne aux oncles maternels ou prise en charge |
| referent_memoire | Personne -> Clan ou Famille | Personne autorisee a valider ou transmettre |

### Champs communs d'une relation

| Champ | Description |
|---|---|
| id | Identifiant interne |
| sujet_id | Premiere personne |
| objet_id | Deuxieme personne, clan ou terre selon le cas |
| type_relation | Pere, mere, conjoint, oncle maternel, etc. |
| date_debut | Si connue |
| date_fin | Si applicable |
| source_id | Source |
| niveau_certitude | A verifier, probable, confirme, conteste |
| confidentialite | Public, familial, sensible, reserve |
| commentaire | Note libre |

## 6. Evenements coutumiers

Un evenement coutumier est central car il explique les changements et conserve la memoire du contexte.

### Types d'evenements

| Type | Description | Effets possibles |
|---|---|---|
| naissance | Naissance d'une personne | Creation de la fiche, lien aux parents, clan initial |
| souffle_oncles_maternels | Souffle ou intervention des oncles maternels a la naissance | Trace du lien maternel |
| mariage | Union et travaux coutumiers associes | Alliance, liens entre familles ou clans |
| deces | Deces et travail coutumier associe | Cloture de vie, obligations, memoire |
| enfant_redonne_oncles_maternels | Enfant redonne aux oncles maternels | Changement possible de nom, clan, droits |
| changement_nom | Changement de nom non lie uniquement a l'enfant redonne aux oncles maternels | Historique d'identite |
| changement_clan | Changement d'appartenance clanique | Historique d'appartenance |
| transmission_terre | Transmission, reconnaissance ou retrait d'un droit | Lien avec terres coutumieres |
| autre | Cas rare non prevu | Description libre obligatoire |

### Champs d'un evenement

| Champ | Type | Remarque |
|---|---|---|
| id | Identifiant interne | Cree automatiquement |
| type_evenement | Choix | Voir liste ci-dessus |
| titre | Texte | Resume lisible |
| date_evenement | Date ou periode | Exacte, approximative ou inconnue |
| lieu | Texte ou lieu structure | Optionnel mais important |
| description | Texte long | Recit de l'evenement |
| personnes_impliquees | Liens multiples | Personne concernee, temoins, oncles, conjoints |
| clans_impliques | Liens multiples | Clans concernes |
| terres_concernees | Liens multiples | Si l'evenement touche les droits ou terres |
| effets_declares | Texte ou liens d'historique | Ex: changement de nom, clan, droits |
| source_id | Source principale | Plusieurs sources possibles via table de liaison |
| niveau_certitude | Choix | A verifier, probable, confirme, conteste |
| confidentialite | Niveau | Souvent familial ou sensible |

## 7. Terres coutumieres

Les terres doivent etre traitees comme sensibles par defaut.

### Champs principaux

| Champ | Type | Remarque |
|---|---|---|
| id | Identifiant interne | Cree automatiquement |
| nom | Texte | Nom de la terre ou du lieu |
| type_lieu | Choix | Terre, chefferie, village, ile, tribu, autre |
| localisation | Texte | Description libre au debut |
| coordonnees | Geographie | Optionnel, a eviter si trop sensible |
| clan_associe_id | Lien vers Clan | Si connu |
| lignee_associee | Texte ou lien futur | A preciser |
| droits_connus | Texte long | Droit d'usage, droit coutumier, restriction |
| statut | Choix | Confirme, a verifier, conteste, sensible |
| source_id | Source | Obligatoire pour les informations de droits |
| confidentialite | Niveau | Sensible par defaut |

## 8. Sources

La source est obligatoire pour toute information structurante : filiation, clan, terre, enfant redonne aux oncles maternels, droits, evenement sensible.

### Champs principaux

| Champ | Type | Remarque |
|---|---|---|
| id | Identifiant interne | Cree automatiquement |
| type_source | Choix | Temoignage oral, reunion, document, photo, audio, video, archive |
| titre | Texte | Ex: Entretien avec X, reunion familiale du ... |
| personne_source_id | Lien vers Personne | Si le temoin est dans la base |
| nom_source_libre | Texte | Si la personne n'est pas encore creee |
| date_recueil | Date | Moment ou l'information est recueillie |
| lieu_recueil | Texte | Optionnel |
| recueilli_par | Texte ou utilisateur | Qui a saisi/collecte |
| resume | Texte long | Resume de ce qui a ete transmis |
| consentement | Choix | Oui, non, inconnu, a confirmer |
| niveau_fiabilite | Choix | A verifier, partiel, solide, confirme |
| confidentialite | Niveau | Selon contenu |

## 9. Pieces jointes

| Champ | Type | Remarque |
|---|---|---|
| id | Identifiant interne | Cree automatiquement |
| fichier | Fichier | Image, audio, PDF, document |
| type_fichier | Choix | Photo, audio, scan, note, autre |
| titre | Texte | Nom lisible |
| description | Texte | Contexte |
| lie_a_type | Choix | Personne, Clan, Evenement, Terre, Source |
| lie_a_id | Identifiant | Objet concerne |
| confidentialite | Niveau | Herite souvent de l'objet lie |

## 10. Niveaux de confidentialite

| Niveau | Description | Exemple |
|---|---|---|
| public | Peut etre partage dans le cercle general autorise | Nom, filiation simple deja connue |
| familial | Reserve a une famille ou branche concernee | Recit familial, photo, details de lignage |
| sensible | Acces restreint, validation requise | Terre, droit, enfant redonne aux oncles maternels, information contestee |
| reserve | Acces tres limite | Information pouvant blesser, exposer ou creer un conflit |

## 11. Niveaux de certitude

| Niveau | Sens |
|---|---|
| a_verifier | Information recueillie mais non confirmee |
| probable | Information coherente mais encore fragile |
| confirme | Information validee par source fiable ou plusieurs sources |
| conteste | Plusieurs versions ou desaccord connu |

## 12. Proposition de tables pour la premiere base

Pour une premiere version simple, on peut demarrer avec ces tables :

| Table | Utilite |
|---|---|
| persons | Fiches personnes |
| person_names | Historique et variantes des noms |
| clans | Fiches clans |
| clan_relations | Alliances, hierarchies et liens entre clans |
| relationships | Relations entre personnes ou entre personne et clan |
| customary_events | Evenements coutumiers |
| event_participants | Personnes impliquees dans un evenement |
| event_clans | Clans impliques dans un evenement |
| lands | Terres coutumieres |
| land_links | Liens entre terres, clans, personnes ou lignees |
| sources | Sources orales/documentaires |
| attachments | Pieces jointes |
| change_history | Historique des changements de nom, clan, droits |
| access_levels | Niveaux de confidentialite |

## 13. Point important pour la suite

Avant de coder, il faudra valider le vocabulaire coutumier.

Les mots "clan parent", "hierarchie", "allie", "enfant redonne aux oncles maternels", "droits", "referent" ou "travail coutumier" doivent etre ajustes avec tes mots a toi et, si possible, avec ceux utilises par les anciens ou les familles concernees. Le modele technique doit s'adapter au vocabulaire culturel, pas l'inverse.
