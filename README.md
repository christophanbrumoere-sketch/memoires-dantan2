# Memoires d'antan

Prototype local d'archivage genealogique et coutumier.

Cette version publiee est une copie technique de la V1. Elle ne contient pas la base de donnees reelle, pas de mot de passe, pas de secret de session, pas d'archives PDF personnelles et pas de sources documentaires privees.

## Technologie

- Python 3
- Serveur HTTP local base sur `http.server.ThreadingHTTPServer`
- SQLite via le module standard `sqlite3`
- HTML/CSS genere cote serveur dans `app.py`
- Aucune dependance web externe obligatoire pour lancer la V1

## Lancer la V1 localement

Depuis ce dossier :

```powershell
python app.py
```

Si `python` n'est pas dans le PATH Windows, utiliser le Python disponible sur la machine, par exemple :

```powershell
& 'C:\Users\chris\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe' app.py
```

Puis ouvrir :

```text
http://127.0.0.1:8765
```

Il est aussi possible d'utiliser :

```text
LANCER_APPLICATION.bat
```

## Donnees locales

Au lancement, la V1 lit et ecrit dans :

```text
genealogie_coutumiere.sqlite3
```

Ce fichier est volontairement ignore par Git. Chaque poste garde sa propre base locale.

Un schema sans donnees personnelles est fourni dans :

```text
schema/genealogie_coutumiere_schema.sql
schema/genealogie_coutumiere_empty.sqlite3
```

## Documentation

- `docs/AUDIT_V1.md` : architecture, base de donnees et fonctionnement actuel.
- `docs/PLAN_COMPATIBILITE_V2.md` : plan de compatibilite pour construire une V2 sans casser la V1.
- `MODELE_DONNEES.md`, `SCHEMA_MODELE_DONNEES.md`, `SPEC_APPLICATION.md` : documents de conception initiaux.

## Confidentialite

Ne jamais publier :

- `genealogie_coutumiere.sqlite3`
- `.session_secret`
- `.env`
- `Sources documentaires/`
- `Archives/`
- exports PDF, Word, Excel contenant des personnes reelles
