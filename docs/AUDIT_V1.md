# Audit V1 - Memoires d'antan

## Resume

La V1 est une application web locale monofichier. Elle sert a saisir, consulter, relier et visualiser des personnes, relations familiales, noms coutumiers, clans, groupes, evenements, sources et terres coutumieres.

Elle fonctionne sans serveur distant : l'application s'ouvre sur `http://127.0.0.1:8765` et les donnees sont conservees dans un fichier SQLite local.

## Technologie utilisee

- Langage : Python 3.
- Serveur web : `http.server.ThreadingHTTPServer`, module standard Python.
- Routage HTTP : classe `AppHandler` dans `app.py`.
- Base de donnees : SQLite via `sqlite3`.
- Interface : HTML/CSS genere directement dans `app.py`.
- Authentification : mot de passe local, hash PBKDF2-HMAC-SHA256, cookie de session signe par HMAC.
- Dependances externes : aucune dependance obligatoire identifiee pour lancer la V1.

## Emplacement et format de la base de donnees

Dans la V1 actuelle :

```python
DB_PATH = Path("genealogie_coutumiere.sqlite3")
```

La base reelle est donc :

```text
genealogie_coutumiere.sqlite3
```

Format :

- SQLite 3.
- Fichier local sur le PC.
- Non publie dans Git.
- Contient les donnees genealogiques personnelles et les mots de passe hashes.

Le secret de signature de session est separe :

```text
.session_secret
```

Ce fichier est egalement local et ne doit jamais etre publie.

## Dossiers contenant photos, documents et exports

Dossiers observes dans le projet V1 :

- `Sources documentaires/` : documents PDF, Markdown, images ou sources documentaires ajoutees au projet. Non publie par defaut, car peut contenir des documents prives, sous droits ou sensibles.
- `Archives/` : exports PDF et fichiers d'archives produits pendant les tests. Non publie par defaut.
- `output/`, `tmp/`, `tmp_pdf_pages/`, `rendered_cahier_des_charges/` : sorties temporaires ou generees.

Le depot GitHub prepare contient uniquement le code, la documentation technique et un schema de base vide.

## Lecture et ecriture des donnees

La V1 centralise l'ouverture SQLite dans :

```python
def db_connect() -> sqlite3.Connection:
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    conn.execute("PRAGMA foreign_keys = ON")
    return conn
```

Les routes HTTP lisent et ecrivent ensuite directement dans SQLite avec des requetes SQL dans `app.py`.

Principes constates :

- `init_db()` cree les tables si elles n'existent pas.
- Certains jeux de donnees documentaires/fictifs peuvent etre ajoutes lors d'une initialisation.
- Les formulaires HTML envoient des requetes `POST`.
- Les handlers executent `INSERT`, `UPDATE` et `DELETE` directement.
- Les suppressions nettoient souvent les liens associes avant suppression de l'entite principale.
- Les relations rapides creent des lignes dans la meme table `relationships` que les relations manuelles.

## Tables et champs principaux

### users

Stocke l'utilisateur local.

- `id`
- `username`
- `password_hash`
- `created_at`

### persons

Fiche personne.

- `id`
- `first_names`
- `current_name`
- `birth_name`
- `other_names`
- `gender`
- `birth_date`
- `birth_place`
- `death_date`
- `current_clan_id`
- `origin_clan_id`
- `notes`
- `confidentiality`
- `certainty`
- `created_at`

Note V1 : `current_clan_id` et `origin_clan_id` restent presents pour compatibilite historique. L'usage fonctionnel evolue vers `person_customary_name_links`.

### clans

Ancienne/actuelle entite clanique, conservee pour compatibilite.

- `id`
- `name`
- `variants`
- `region`
- `description`
- `confidentiality`
- `certainty`
- `created_at`

### customary_names

Noms coutumiers, par exemple les noms chantes dans les vivaa.

- `id`
- `name`
- `name_type`
- `variants`
- `region`
- `description`
- `source_id`
- `confidentiality`
- `certainty`
- `created_at`

### customary_name_relations

Liens entre noms coutumiers, notamment alliances.

- `id`
- `name_a_id`
- `name_b_id`
- `relation_type`
- `context`
- `source_id`
- `confidentiality`
- `certainty`
- `created_at`

### person_customary_name_links

Association entre une personne et un nom coutumier.

- `id`
- `person_id`
- `customary_name_id`
- `link_type`
- `comment`
- `confidentiality`
- `certainty`
- `created_at`

### customary_groups

Groupes/lignages conserves comme entite distincte.

- `id`
- `name`
- `group_type`
- `variants`
- `region`
- `description`
- `source_id`
- `confidentiality`
- `certainty`
- `created_at`

### person_group_links

Association entre personne et groupe/lignage.

- `id`
- `person_id`
- `group_id`
- `link_type`
- `comment`
- `confidentiality`
- `certainty`
- `created_at`

### relationships

Relations entre personnes ou vers clan. Les relations rapides et manuelles utilisent cette table.

- `id`
- `subject_person_id`
- `object_person_id`
- `object_clan_id`
- `relation_type`
- `comment`
- `confidentiality`
- `certainty`
- `created_at`

### inferred_relationship_exclusions

Permet de masquer/supprimer des relations deduites sans supprimer une relation source.

- `id`
- `person_a_id`
- `person_b_id`
- `relation_type`
- `created_at`

### customary_events

Evenements coutumiers.

- `id`
- `event_type`
- `title`
- `event_date`
- `place`
- `main_person_id`
- `description`
- `effects`
- `source_id`
- `confidentiality`
- `certainty`
- `created_at`

### event_person_links

Personnes liees a un evenement avec role.

- `id`
- `event_id`
- `person_id`
- `role`
- `comment`
- `confidentiality`
- `certainty`
- `created_at`

### event_clans

Clans lies a un evenement.

- `event_id`
- `clan_id`

### sources

Sources orales, ecrites, documentaires.

- `id`
- `source_type`
- `title`
- `witness_name`
- `collection_date`
- `collected_by`
- `summary`
- `consent`
- `confidentiality`
- `reliability`
- `created_at`

### lands

Terres coutumieres.

- `id`
- `name`
- `place_type`
- `location_text`
- `clan_id`
- `known_rights`
- `status`
- `source_id`
- `confidentiality`
- `created_at`

### group_relations

Relations entre groupes/lignages.

- `id`
- `group_a_id`
- `group_b_id`
- `relation_type`
- `context`
- `source_id`
- `confidentiality`
- `certainty`
- `created_at`

### viva_lists

Listes viva.

- `id`
- `title`
- `area`
- `collector_author`
- `collection_date`
- `description`
- `source_id`
- `confidentiality`
- `certainty`
- `created_at`

### viva_entries

Entrees detaillees dans une liste viva.

- `id`
- `viva_list_id`
- `position`
- `section_name`
- `raw_text`
- `group_a_id`
- `group_b_id`
- `translation`
- `note`
- `confidentiality`
- `certainty`
- `created_at`

### research_items

Notes d'analyse/recherche.

- `id`
- `subject_type`
- `subject_id`
- `title`
- `statement`
- `interpretation`
- `author_view`
- `source_id`
- `evidence_level`
- `confidentiality`
- `certainty`
- `created_at`

### lineage_genealogies

Genealogies textuelles de lignage/groupe.

- `id`
- `group_id`
- `title`
- `author_or_collector`
- `chain_text`
- `interpretation`
- `source_id`
- `confidentiality`
- `certainty`
- `created_at`

### customary_functions

Fonctions coutumieres associees a un groupe ou une personne.

- `id`
- `group_id`
- `person_id`
- `function_type`
- `title`
- `place`
- `description`
- `source_id`
- `confidentiality`
- `certainty`
- `created_at`

### change_history

Historique des changements d'appartenance, nom, statut ou autre element.

- `id`
- `person_id`
- `change_type`
- `old_value`
- `new_value`
- `effective_date`
- `event_id`
- `source_id`
- `comment`
- `confidentiality`
- `certainty`
- `created_at`

## Relations principales

- `persons.current_clan_id` -> `clans.id`
- `persons.origin_clan_id` -> `clans.id`
- `relationships.subject_person_id` -> `persons.id`
- `relationships.object_person_id` -> `persons.id`
- `relationships.object_clan_id` -> `clans.id`
- `person_customary_name_links.person_id` -> `persons.id`
- `person_customary_name_links.customary_name_id` -> `customary_names.id`
- `person_group_links.person_id` -> `persons.id`
- `person_group_links.group_id` -> `customary_groups.id`
- `customary_name_relations.name_a_id/name_b_id` -> `customary_names.id`
- `customary_events.main_person_id` -> `persons.id`
- `event_person_links.event_id` -> `customary_events.id`
- `event_person_links.person_id` -> `persons.id`
- `event_clans.event_id` -> `customary_events.id`
- `event_clans.clan_id` -> `clans.id`
- `sources` est reference par plusieurs entites documentaires.

## Elements non publies

Exclus volontairement :

- base reelle `genealogie_coutumiere.sqlite3`
- `.session_secret`
- fichiers `.env`
- dossiers `Sources documentaires/` et `Archives/`
- exports PDF/Word/Excel
- caches et logs

## Artefacts fournis pour la V2

- `schema/genealogie_coutumiere_schema.sql` : schema SQL sans donnees.
- `schema/genealogie_coutumiere_empty.sqlite3` : base vide, sans utilisateur, sans personnes, sans sources.

