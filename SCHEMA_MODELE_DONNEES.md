# Schéma du modèle de données

Ce fichier sert de carte visuelle commune pour discuter de la structure de l'outil.

Le diagramme ci-dessous est écrit en Mermaid. Dans Visual Studio Code, il peut être lu comme du Markdown. Si l'aperçu Mermaid n'est pas disponible, copier le bloc dans https://mermaid.live/.

```mermaid
erDiagram
    PERSONS {
        int id PK
        text first_names
        text current_name
        text birth_name
        text other_names
        text gender
        text birth_date
        text birth_place
        text death_date
        int current_clan_id FK
        int origin_clan_id FK
        text notes
        text confidentiality
        text certainty
    }

    CLANS {
        int id PK
        text name
        text variants
        text region
        text description
        text confidentiality
        text certainty
    }

    CUSTOMARY_GROUPS {
        int id PK
        text name
        text group_type
        text variants
        text region
        text description
        int source_id FK
        text confidentiality
        text certainty
    }

    PERSON_GROUP_LINKS {
        int id PK
        int person_id FK
        int group_id FK
        text link_type
        text comment
        text confidentiality
        text certainty
    }

    RELATIONSHIPS {
        int id PK
        int subject_person_id FK
        int object_person_id FK
        int object_clan_id FK
        text relation_type
        text comment
        text confidentiality
        text certainty
    }

    CUSTOMARY_EVENTS {
        int id PK
        text event_type
        text title
        text event_date
        text place
        int main_person_id FK
        text description
        text effects
        int source_id FK
        text confidentiality
        text certainty
    }

    EVENT_PERSON_LINKS {
        int id PK
        int event_id FK
        int person_id FK
        text role
        text comment
        text confidentiality
        text certainty
    }

    EVENT_CLANS {
        int event_id FK
        int clan_id FK
    }

    SOURCES {
        int id PK
        text source_type
        text title
        text witness_name
        text collection_date
        text collected_by
        text summary
        text consent
        text confidentiality
        text reliability
    }

    LANDS {
        int id PK
        text name
        text place_type
        text location_text
        int clan_id FK
        text known_rights
        text status
        int source_id FK
        text confidentiality
    }

    GROUP_RELATIONS {
        int id PK
        int group_a_id FK
        int group_b_id FK
        text relation_type
        text context
        int source_id FK
        text confidentiality
        text certainty
    }

    VIVA_LISTS {
        int id PK
        text title
        text area
        text collector_author
        text collection_date
        text description
        int source_id FK
        text confidentiality
        text certainty
    }

    VIVA_ENTRIES {
        int id PK
        int viva_list_id FK
        int position
        text section_name
        text raw_text
        int group_a_id FK
        int group_b_id FK
        text translation
        text note
        text confidentiality
        text certainty
    }

    RESEARCH_ITEMS {
        int id PK
        text subject_type
        int subject_id
        text title
        text statement
        text interpretation
        text author_view
        int source_id FK
        text evidence_level
        text confidentiality
        text certainty
    }

    LINEAGE_GENEALOGIES {
        int id PK
        int group_id FK
        text title
        text author_or_collector
        text chain_text
        text interpretation
        int source_id FK
        text confidentiality
        text certainty
    }

    CUSTOMARY_FUNCTIONS {
        int id PK
        int group_id FK
        int person_id FK
        text function_type
        text title
        text place
        text description
        int source_id FK
        text confidentiality
        text certainty
    }

    CHANGE_HISTORY {
        int id PK
        int person_id FK
        text change_type
        text old_value
        text new_value
        text effective_date
        int event_id FK
        int source_id FK
        text comment
        text confidentiality
        text certainty
    }

    CLANS ||--o{ PERSONS : "clan actuel"
    CLANS ||--o{ PERSONS : "clan origine"
    PERSONS ||--o{ RELATIONSHIPS : "sujet"
    PERSONS ||--o{ RELATIONSHIPS : "personne liée"
    CLANS ||--o{ RELATIONSHIPS : "clan lié"

    PERSONS ||--o{ PERSON_GROUP_LINKS : "appartenance"
    CUSTOMARY_GROUPS ||--o{ PERSON_GROUP_LINKS : "groupe lié"

    PERSONS ||--o{ CUSTOMARY_EVENTS : "personne principale"
    CUSTOMARY_EVENTS ||--o{ EVENT_PERSON_LINKS : "personnes avec rôle"
    PERSONS ||--o{ EVENT_PERSON_LINKS : "rôle dans événement"
    CUSTOMARY_EVENTS ||--o{ EVENT_CLANS : "clans concernés"
    CLANS ||--o{ EVENT_CLANS : "événement"

    CLANS ||--o{ LANDS : "terre associée"
    SOURCES ||--o{ LANDS : "source"
    SOURCES ||--o{ CUSTOMARY_EVENTS : "source"
    SOURCES ||--o{ CUSTOMARY_GROUPS : "source"

    CUSTOMARY_GROUPS ||--o{ GROUP_RELATIONS : "groupe A"
    CUSTOMARY_GROUPS ||--o{ GROUP_RELATIONS : "groupe B"
    SOURCES ||--o{ GROUP_RELATIONS : "source"

    SOURCES ||--o{ VIVA_LISTS : "source"
    VIVA_LISTS ||--o{ VIVA_ENTRIES : "entrées"
    CUSTOMARY_GROUPS ||--o{ VIVA_ENTRIES : "groupe A"
    CUSTOMARY_GROUPS ||--o{ VIVA_ENTRIES : "groupe B"

    CUSTOMARY_GROUPS ||--o{ LINEAGE_GENEALOGIES : "généalogie"
    SOURCES ||--o{ LINEAGE_GENEALOGIES : "source"

    CUSTOMARY_GROUPS ||--o{ CUSTOMARY_FUNCTIONS : "fonction"
    PERSONS ||--o{ CUSTOMARY_FUNCTIONS : "fonction portée"
    SOURCES ||--o{ CUSTOMARY_FUNCTIONS : "source"

    SOURCES ||--o{ RESEARCH_ITEMS : "source"

    PERSONS ||--o{ CHANGE_HISTORY : "historique"
    CUSTOMARY_EVENTS ||--o{ CHANGE_HISTORY : "événement lié"
    SOURCES ||--o{ CHANGE_HISTORY : "source"
```

## Lecture rapide

- `PERSONS` garde l'identité individuelle.
- `CLANS` reste séparé pour les cas où l'appartenance clanique est claire.
- `CUSTOMARY_GROUPS` contient les clans incertains, lignages, noms de famille, branches, chefferies ou noms cités dans les viva.
- `PERSON_GROUP_LINKS` relie une personne à un groupe/lignage sans forcer ce groupe à devenir un clan.
- `CUSTOMARY_EVENTS` stocke les événements coutumiers.
- `EVENT_PERSON_LINKS` relie plusieurs personnes à un événement avec un rôle, par exemple époux, épouse, enfant redonné, oncle maternel concerné.
- `SOURCES` permet de garder la trace de l'origine d'une information.
- `RESEARCH_ITEMS` permet de conserver des hypothèses, interprétations et versions d'auteurs.
