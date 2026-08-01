# Specification application - version initiale

Projet : outil d'archivage genealogique, clanique et coutumier en Nouvelle-Caledonie.

Ce document decrit la premiere version concrete de l'application a construire. Il complete le fichier `MODELE_DONNEES.md`, qui decrit les objets metier.

## 1. Objectif de la premiere version

La premiere version doit permettre de saisir, consulter et relier les informations essentielles sans chercher a couvrir tous les cas complexes immediatement.

Objectif prioritaire :

> Creer une base privee permettant d'enregistrer des personnes, leurs familles, leurs clans, leurs evenements coutumiers, leurs sources et les changements importants de leur vie.

Cette premiere version doit etre :

| Critere | Choix recommande |
|---|---|
| Type d'application | Application locale sur PC |
| Connexion internet | Non necessaire pour fonctionner |
| Base de donnees | SQLite au depart |
| Public initial | Toi, puis eventuellement quelques personnes de confiance |
| Priorite | Fiabilite des donnees et simplicite de saisie |
| Donnees sensibles | Protegees par niveau de confidentialite des le depart |

## 2. Modules de la premiere version

| Module | Role | Priorite |
|---|---|---|
| Tableau de bord | Voir rapidement le contenu de la base | Haute |
| Personnes | Creer et consulter les fiches individuelles | Tres haute |
| Relations familiales | Relier parents, enfants, conjoints, oncles maternels | Tres haute |
| Clans | Creer les clans et leurs relations | Haute |
| Evenements coutumiers | Enregistrer naissance, mariage, deces, enfant redonne aux oncles maternels | Tres haute |
| Sources | Documenter l'origine des informations | Tres haute |
| Terres coutumieres | Archiver les terres et droits connus | Haute mais sensible |
| Recherche | Retrouver rapidement une personne, un clan, une source | Haute |
| Confidentialite | Marquer les informations sensibles | Tres haute |
| Export | Exporter ou sauvegarder les donnees | Moyenne pour V1, haute ensuite |

## 3. Navigation generale

L'application doit rester simple. Une barre de navigation principale suffit au depart.

| Menu | Ecran ouvert |
|---|---|
| Accueil | Tableau de bord |
| Personnes | Liste des personnes |
| Clans | Liste des clans |
| Evenements | Liste des evenements coutumiers |
| Sources | Liste des sources |
| Terres | Liste des terres coutumieres |
| Recherche | Recherche globale |
| Parametres | Listes de reference, sauvegarde, confidentialite |

## 4. Ecran Accueil

L'accueil doit donner une vue simple de l'etat de la base.

### Informations affichees

| Element | Exemple |
|---|---|
| Nombre de personnes | 125 personnes enregistrees |
| Nombre de clans | 18 clans |
| Nombre d'evenements | 42 evenements coutumiers |
| Informations a verifier | 12 elements avec certitude "a verifier" |
| Informations sensibles | 7 elements marques sensibles ou reserves |

### Actions rapides

| Bouton | Action |
|---|---|
| Ajouter une personne | Ouvre le formulaire Personne |
| Ajouter un clan | Ouvre le formulaire Clan |
| Ajouter un evenement | Ouvre le formulaire Evenement |
| Ajouter une source | Ouvre le formulaire Source |
| Rechercher | Ouvre la recherche globale |

## 5. Module Personnes

### Liste des personnes

La liste doit permettre de retrouver rapidement une fiche.

| Colonne | Description |
|---|---|
| Nom affiche | Prenoms + nom actuel |
| Nom de naissance | Si different ou connu |
| Clan actuel | Clan principal affiche |
| Clan d'origine | Si connu |
| Naissance | Date ou periode |
| Statut | Vivant, decede, inconnu |
| Confidentialite | Public, familial, sensible, reserve |

### Filtres utiles

| Filtre | Utilite |
|---|---|
| Nom ou prenom | Recherche rapide |
| Clan | Voir les personnes rattachees a un clan |
| Statut | Vivant, decede, inconnu |
| Certitude | Voir les fiches a verifier |
| Confidentialite | Identifier les fiches sensibles |

### Fiche personne

La fiche personne est l'ecran central.

Elle doit contenir les onglets suivants :

| Onglet | Contenu |
|---|---|
| Identite | Prenoms, noms, naissance, deces, notes |
| Famille | Parents, enfants, conjoints, fratrie |
| Clans | Clan actuel, clan d'origine, clan maternel, clan paternel |
| Evenements | Liste des evenements coutumiers lies |
| Sources | Sources justifiant les informations |
| Historique | Changements de nom, clan, droits ou statut |
| Pieces jointes | Photos, documents, audio |

### Formulaire Personne

| Champ | Obligatoire | Remarque |
|---|---|---|
| Prenom principal | Oui | Meme si d'autres prenoms existent |
| Autres prenoms | Non | Liste possible |
| Nom actuel | Oui | Si inconnu, autoriser "inconnu" |
| Nom de naissance | Non | Important si changement de nom |
| Sexe | Non | Ne pas bloquer la saisie |
| Date de naissance | Non | Date exacte ou approximative |
| Lieu de naissance | Non | Texte libre au depart |
| Date de deces | Non | Optionnel |
| Clan actuel | Non | Lien vers un clan |
| Clan d'origine | Non | Lien vers un clan |
| Notes | Non | Texte libre |
| Niveau de confidentialite | Oui | Familial par defaut |
| Source principale | Non mais recommande | A rendre obligatoire plus tard pour donnees sensibles |

## 6. Module Relations familiales et coutumieres

Les relations doivent pouvoir etre ajoutees depuis une fiche personne.

### Types de relations pour V1

| Type | Exemple |
|---|---|
| Pere | A est le pere de B |
| Mere | A est la mere de B |
| Enfant | B est l'enfant de A |
| Conjoint | A est ou a ete conjoint de B |
| Frere / soeur | A et B sont de meme fratrie |
| Oncle maternel | A est oncle maternel de B |
| Tante maternelle | A est tante maternelle de B |
| Parent coutumier | A a un role parental coutumier pour B |
| Referent memoire | A est referent pour une famille, branche ou clan |

### Regle importante

Chaque relation importante doit pouvoir avoir :

| Champ | Utilite |
|---|---|
| Source | Qui transmet ou confirme le lien |
| Certitude | A verifier, probable, confirme, conteste |
| Confidentialite | Public, familial, sensible, reserve |
| Commentaire | Detail ou nuance |

## 7. Module Clans

### Liste des clans

| Colonne | Description |
|---|---|
| Nom du clan | Nom principal |
| Variantes | Autres noms ou orthographes |
| Aire / region | Si connue |
| Clan parent | Si une hierarchie est renseignee |
| Nombre de personnes liees | Indicateur |
| Confidentialite | Niveau general |

### Fiche clan

| Onglet | Contenu |
|---|---|
| Identite | Nom, variantes, region, description |
| Relations claniques | Alliances, hierarchie, clans lies |
| Personnes | Personnes rattachees au clan |
| Terres | Terres coutumieres associees |
| Sources | Sources des informations |
| Notes sensibles | Informations restreintes |

### Relations entre clans

| Type | Description |
|---|---|
| Alliance | Clan allie |
| Hierarchie | Relation de rang ou responsabilite |
| Origine | Clan d'origine d'une branche |
| Lien maternel | Clan maternel lie a une personne ou lignee |
| Reception d'enfant redonne | Clan recevant dans le cas d'un enfant redonne aux oncles maternels |
| Relation contestee | Lien a verifier ou conteste |

## 8. Module Evenements coutumiers

### Liste des evenements

| Colonne | Description |
|---|---|
| Date ou periode | Quand l'evenement a eu lieu |
| Type | Naissance, mariage, deces, etc. |
| Titre | Resume court |
| Personne principale | Personne concernee |
| Clans concernes | Si renseignes |
| Certitude | Niveau de confiance |
| Confidentialite | Niveau d'acces |

### Types d'evenements V1

| Type | A prevoir en V1 |
|---|---|
| Naissance | Oui |
| Souffle des oncles maternels | Oui |
| Mariage | Oui |
| Deces | Oui |
| Enfant redonne aux oncles maternels | Oui |
| Changement de nom | Oui |
| Changement de clan | Oui |
| Transmission ou droit de terre | Oui mais sensible |
| Autre evenement coutumier | Oui |

### Formulaire Evenement

| Champ | Obligatoire | Remarque |
|---|---|---|
| Type d'evenement | Oui | Liste controlee |
| Titre | Oui | Resume lisible |
| Date ou periode | Non | Autoriser approximation |
| Lieu | Non | Texte libre |
| Personne principale | Oui si applicable | Personne concernee |
| Personnes impliquees | Non | Temoins, oncles, conjoints, parents |
| Clans impliques | Non | Clans concernes |
| Terres concernees | Non | Surtout pour droits |
| Description | Oui | Recit de l'evenement |
| Effets | Non | Changement de nom, clan, droits |
| Source | Oui | Important pour garder la provenance |
| Certitude | Oui | A verifier par defaut |
| Confidentialite | Oui | Familial par defaut, sensible si besoin |

## 9. Module Sources

### Liste des sources

| Colonne | Description |
|---|---|
| Titre | Nom lisible de la source |
| Type | Oral, reunion, document, photo, audio |
| Personne source | Temoin ou transmetteur |
| Date de recueil | Quand l'information a ete collectee |
| Fiabilite | A verifier, partiel, solide, confirme |
| Confidentialite | Niveau d'acces |

### Formulaire Source

| Champ | Obligatoire | Remarque |
|---|---|---|
| Type de source | Oui | Temoignage oral, document, photo, audio |
| Titre | Oui | Ex: Entretien avec ... |
| Personne source | Non | Lien vers une personne si elle existe |
| Nom source libre | Non | Si pas encore dans la base |
| Date de recueil | Non mais recommande | Date de collecte |
| Recueilli par | Non | Toi ou autre personne |
| Resume | Oui | Ce que la source transmet |
| Consentement | Oui | Oui, non, inconnu, a confirmer |
| Fiabilite | Oui | A verifier par defaut |
| Confidentialite | Oui | Selon contenu |

## 10. Module Terres coutumieres

Ce module doit etre present dans la structure, mais manipule avec prudence.

### Regle de depart

Toute terre ou information de droit est marquee `sensible` par defaut.

### Fiche Terre

| Champ | Obligatoire | Remarque |
|---|---|---|
| Nom du lieu ou de la terre | Oui | Nom connu |
| Type de lieu | Non | Terre, village, tribu, ile, autre |
| Localisation textuelle | Non | Pas de coordonnees obligatoires au debut |
| Clan associe | Non | Lien vers clan |
| Personnes ou lignees liees | Non | Si connu |
| Droits connus | Non | Texte sensible |
| Statut | Oui | A verifier par defaut |
| Source | Oui | Obligatoire pour droits |
| Confidentialite | Oui | Sensible par defaut |

## 11. Recherche globale

La recherche doit interroger plusieurs types de donnees.

| Recherche | Resultats attendus |
|---|---|
| Nom d'une personne | Personnes, sources, evenements associes |
| Nom de clan | Clan, personnes liees, terres, evenements |
| Mot cle | Notes, descriptions, sources |
| Type d'evenement | Liste des evenements correspondants |
| Statut a verifier | Donnees a confirmer |

## 12. Sauvegarde et export

La premiere version doit prevoir un minimum de securite.

| Fonction | V1 | Remarque |
|---|---|---|
| Sauvegarde locale | Oui | Copie du fichier SQLite |
| Export CSV | Oui plus tard | Utile pour relecture |
| Export PDF/Word d'une fiche | Plus tard | Utile pour partager avec famille |
| Export complet archive | Plus tard | Donnees + pieces jointes |
| Mot de passe application | A evaluer | Important si donnees sensibles |

## 13. Regles de saisie importantes

1. Une donnee sensible doit toujours avoir un niveau de confidentialite.
2. Une information de terre ou de droit doit toujours avoir une source.
3. Une relation contestee ne doit pas etre supprimee : elle doit etre marquee comme contestee.
4. Un changement de nom ou de clan doit etre historise.
5. Un enfant redonne aux oncles maternels doit etre un evenement a part entiere, pas une simple note.
6. Les dates approximatives doivent etre autorisees.
7. Les variantes de noms doivent etre conservees.

## 14. Premiere maquette technique proposee

Pour coder vite et proprement, la premiere version peut etre une application web locale.

| Element | Proposition |
|---|---|
| Interface | Application web locale dans le navigateur |
| Backend | Python Flask ou Node.js |
| Base | SQLite |
| Donnees | Stockees dans le dossier du projet |
| Avantage | Simple a lancer, facile a sauvegarder, evolutif |

## 15. Ordre de developpement recommande

| Etape | Resultat attendu |
|---|---|
| 1 | Creer la base SQLite avec les tables principales |
| 2 | Creer l'ecran Accueil |
| 3 | Creer liste + formulaire Personnes |
| 4 | Creer liste + formulaire Clans |
| 5 | Ajouter relations Personne-Personne et Personne-Clan |
| 6 | Ajouter evenements coutumiers |
| 7 | Ajouter sources |
| 8 | Ajouter recherche globale |
| 9 | Ajouter terres coutumieres |
| 10 | Ajouter sauvegarde/export |

## 16. Questions a valider avant codage

| Question | Decision proposee pour demarrer |
|---|---|
| Application locale ou en ligne ? | Locale d'abord |
| Faut-il un mot de passe des la V1 ? | Oui si l'outil contient vite des donnees reelles |
| Peut-on saisir une personne sans source ? | Oui, mais les donnees sensibles exigent une source |
| Peut-on saisir une date approximative ? | Oui |
| Les terres sont-elles visibles dans la navigation principale ? | Oui, mais marquees sensibles par defaut |
| Faut-il commencer avec des donnees fictives ? | Oui pour tester sans exposer de vraies informations |

