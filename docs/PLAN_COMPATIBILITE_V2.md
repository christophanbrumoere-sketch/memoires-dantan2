# Plan de compatibilite V2

## Objectif

Construire une V2 plus robuste sans casser la V1 ni perdre la possibilite de relire la base SQLite actuelle.

La V1 doit continuer a fonctionner localement avec `genealogie_coutumiere.sqlite3`.

## Principes

1. Ne jamais modifier directement la base reelle sans sauvegarde.
2. Conserver une migration reversible ou documentee.
3. Separer progressivement le code en couches :
   - acces donnees ;
   - logique metier ;
   - rendu HTML/API ;
   - visualisation/export.
4. Garder SQLite comme format local tant que le projet reste personnel/familial.
5. Prevoir une compatibilite future PostgreSQL ou autre SGBD si le projet s'elargit.

## Compatibilite donnees

La V2 devra savoir lire :

- `persons`
- `relationships`
- `customary_names`
- `person_customary_name_links`
- `customary_groups`
- `person_group_links`
- `customary_events`
- `event_person_links`
- `sources`
- `lands`

Les champs historiques `current_clan_id` et `origin_clan_id` doivent rester lisibles, meme si l'interface met en avant les noms coutumiers.

## Migration proposee

### Etape 1 - Gel V1

- Conserver `app.py` fonctionnel.
- Documenter le schema actuel.
- Ajouter des sauvegardes automatiques avant toute future migration.

### Etape 2 - Couche d'acces aux donnees

Extraire les requetes SQL vers un module dedie, par exemple :

```text
memoires_dantan/
  db.py
  repositories/
    persons.py
    relationships.py
    customary_names.py
    events.py
```

But : eviter que l'interface manipule directement toutes les requetes.

### Etape 3 - Schema versionne

Ajouter une table de version :

```sql
CREATE TABLE IF NOT EXISTS schema_migrations (
    version TEXT PRIMARY KEY,
    applied_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
```

Chaque changement futur doit etre un script de migration numerote.

### Etape 4 - API locale

Introduire progressivement des routes JSON pour :

- recherche de personnes ;
- creation en masse ;
- relations rapides ;
- visualisations ;
- export PDF.

La meme logique pourra ensuite etre reprise par ChatGPT Web ou une interface moderne.

### Etape 5 - Protection des donnees

Prevoir :

- export anonymise ;
- niveaux de confidentialite ;
- consentement/source pour informations sensibles ;
- sauvegardes locales chiffrees ;
- journal d'audit des suppressions et modifications importantes.

## Recommandations pour ChatGPT Web

Pour reprendre le projet depuis ChatGPT Web :

1. Utiliser le depot GitHub comme base de code.
2. Ne jamais importer la base personnelle reelle dans un environnement cloud.
3. Developper sur `schema/genealogie_coutumiere_empty.sqlite3`.
4. Ajouter des donnees fictives de test separees si necessaire.
5. Tester les migrations localement avant application sur la base reelle.

## Evolutions techniques possibles

### Option A - V2 locale Python

- Garder SQLite.
- Remplacer progressivement le monofichier par une petite application structuree.
- Ajouter tests automatises.
- Avantage : simple, local, faible risque.

### Option B - Backend Python + frontend moderne

- Backend FastAPI ou Flask.
- Frontend React/Vite ou equivalent.
- SQLite local au depart.
- Avantage : meilleure interface et visualisations.

### Option C - SGBD plus lourd

- PostgreSQL si plusieurs utilisateurs ou gros volume.
- Migration possible car le modele actuel est relationnel.
- Necessite une vraie gestion des droits, sauvegardes et deploiement.

## Points a surveiller

- Relations familiales : eviter les doublons logiques.
- Relations deduites : distinguer relation saisie, relation deduite, relation exclue.
- Noms coutumiers : clarifier leur place par rapport aux clans et groupes.
- Donnees coutumieres sensibles : gerer les droits de consultation.
- Exports PDF : garantir lisibilite A4/A3 et absence d'informations masquees.
- Sources documentaires : separer metadata, fichier local, citation, fiabilite.

## Definition d'une V2 compatible

Une V2 est compatible si :

- elle peut ouvrir une copie de la base V1 ;
- elle affiche correctement les personnes, relations et noms coutumiers ;
- elle ne supprime pas de champs historiques ;
- elle cree une sauvegarde avant migration ;
- elle peut exporter une base compatible ou documenter clairement les changements.
