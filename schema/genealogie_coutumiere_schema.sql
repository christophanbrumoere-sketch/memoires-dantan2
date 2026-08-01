-- Schema-only export for Memoires d'antan V1.
-- No personal genealogical data, no users, no password hashes, no secrets.
-- Generated from the local V1 SQLite database structure.
PRAGMA foreign_keys=ON;

-- table: change_history
CREATE TABLE change_history (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                person_id INTEGER NOT NULL,
                change_type TEXT NOT NULL,
                old_value TEXT,
                new_value TEXT,
                effective_date TEXT,
                event_id INTEGER,
                source_id INTEGER,
                comment TEXT,
                confidentiality TEXT NOT NULL DEFAULT 'familial',
                certainty TEXT NOT NULL DEFAULT 'a_verifier',
                created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (person_id) REFERENCES persons(id),
                FOREIGN KEY (event_id) REFERENCES customary_events(id),
                FOREIGN KEY (source_id) REFERENCES sources(id)
            );

-- table: clans
CREATE TABLE clans (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                variants TEXT,
                region TEXT,
                description TEXT,
                confidentiality TEXT NOT NULL DEFAULT 'familial',
                certainty TEXT NOT NULL DEFAULT 'a_verifier',
                created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
            );

-- table: customary_events
CREATE TABLE customary_events (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                event_type TEXT NOT NULL,
                title TEXT NOT NULL,
                event_date TEXT,
                place TEXT,
                main_person_id INTEGER,
                description TEXT NOT NULL,
                effects TEXT,
                source_id INTEGER,
                confidentiality TEXT NOT NULL DEFAULT 'familial',
                certainty TEXT NOT NULL DEFAULT 'a_verifier',
                created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (main_person_id) REFERENCES persons(id),
                FOREIGN KEY (source_id) REFERENCES sources(id)
            );

-- table: customary_functions
CREATE TABLE customary_functions (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                group_id INTEGER,
                person_id INTEGER,
                function_type TEXT NOT NULL,
                title TEXT NOT NULL,
                place TEXT,
                description TEXT NOT NULL,
                source_id INTEGER,
                confidentiality TEXT NOT NULL DEFAULT 'familial',
                certainty TEXT NOT NULL DEFAULT 'a_verifier',
                created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (group_id) REFERENCES customary_groups(id),
                FOREIGN KEY (person_id) REFERENCES persons(id),
                FOREIGN KEY (source_id) REFERENCES sources(id)
            );

-- table: customary_groups
CREATE TABLE customary_groups (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                group_type TEXT NOT NULL DEFAULT 'a_verifier',
                variants TEXT,
                region TEXT,
                description TEXT,
                source_id INTEGER,
                confidentiality TEXT NOT NULL DEFAULT 'familial',
                certainty TEXT NOT NULL DEFAULT 'a_verifier',
                created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (source_id) REFERENCES sources(id)
            );

-- table: customary_name_relations
CREATE TABLE customary_name_relations (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name_a_id INTEGER NOT NULL,
                name_b_id INTEGER NOT NULL,
                relation_type TEXT NOT NULL DEFAULT 'allie_a',
                context TEXT,
                source_id INTEGER,
                confidentiality TEXT NOT NULL DEFAULT 'familial',
                certainty TEXT NOT NULL DEFAULT 'a_verifier',
                created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (name_a_id) REFERENCES customary_names(id),
                FOREIGN KEY (name_b_id) REFERENCES customary_names(id),
                FOREIGN KEY (source_id) REFERENCES sources(id)
            );

-- table: customary_names
CREATE TABLE customary_names (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                name_type TEXT NOT NULL DEFAULT 'a_verifier',
                variants TEXT,
                region TEXT,
                description TEXT,
                source_id INTEGER,
                confidentiality TEXT NOT NULL DEFAULT 'familial',
                certainty TEXT NOT NULL DEFAULT 'a_verifier',
                created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (source_id) REFERENCES sources(id)
            );

-- table: event_clans
CREATE TABLE event_clans (
                event_id INTEGER NOT NULL,
                clan_id INTEGER NOT NULL,
                PRIMARY KEY (event_id, clan_id),
                FOREIGN KEY (event_id) REFERENCES customary_events(id) ON DELETE CASCADE,
                FOREIGN KEY (clan_id) REFERENCES clans(id) ON DELETE CASCADE
            );

-- table: event_person_links
CREATE TABLE event_person_links (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                event_id INTEGER NOT NULL,
                person_id INTEGER NOT NULL,
                role TEXT NOT NULL,
                comment TEXT,
                confidentiality TEXT NOT NULL DEFAULT 'familial',
                certainty TEXT NOT NULL DEFAULT 'a_verifier',
                created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (event_id) REFERENCES customary_events(id) ON DELETE CASCADE,
                FOREIGN KEY (person_id) REFERENCES persons(id) ON DELETE CASCADE
            );

-- table: group_relations
CREATE TABLE group_relations (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                group_a_id INTEGER NOT NULL,
                group_b_id INTEGER NOT NULL,
                relation_type TEXT NOT NULL,
                context TEXT,
                source_id INTEGER,
                confidentiality TEXT NOT NULL DEFAULT 'familial',
                certainty TEXT NOT NULL DEFAULT 'a_verifier',
                created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (group_a_id) REFERENCES customary_groups(id),
                FOREIGN KEY (group_b_id) REFERENCES customary_groups(id),
                FOREIGN KEY (source_id) REFERENCES sources(id)
            );

-- table: inferred_relationship_exclusions
CREATE TABLE inferred_relationship_exclusions (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                person_a_id INTEGER NOT NULL,
                person_b_id INTEGER NOT NULL,
                relation_type TEXT NOT NULL,
                created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
                UNIQUE(person_a_id, person_b_id, relation_type),
                FOREIGN KEY (person_a_id) REFERENCES persons(id) ON DELETE CASCADE,
                FOREIGN KEY (person_b_id) REFERENCES persons(id) ON DELETE CASCADE
            );

-- table: lands
CREATE TABLE lands (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                place_type TEXT,
                location_text TEXT,
                clan_id INTEGER,
                known_rights TEXT,
                status TEXT NOT NULL DEFAULT 'a_verifier',
                source_id INTEGER,
                confidentiality TEXT NOT NULL DEFAULT 'sensible',
                created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (clan_id) REFERENCES clans(id),
                FOREIGN KEY (source_id) REFERENCES sources(id)
            );

-- table: lineage_genealogies
CREATE TABLE lineage_genealogies (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                group_id INTEGER,
                title TEXT NOT NULL,
                author_or_collector TEXT,
                chain_text TEXT NOT NULL,
                interpretation TEXT,
                source_id INTEGER,
                confidentiality TEXT NOT NULL DEFAULT 'familial',
                certainty TEXT NOT NULL DEFAULT 'a_verifier',
                created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (group_id) REFERENCES customary_groups(id),
                FOREIGN KEY (source_id) REFERENCES sources(id)
            );

-- table: person_customary_name_links
CREATE TABLE person_customary_name_links (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                person_id INTEGER NOT NULL,
                customary_name_id INTEGER NOT NULL,
                link_type TEXT NOT NULL DEFAULT 'rattache_a',
                comment TEXT,
                confidentiality TEXT NOT NULL DEFAULT 'familial',
                certainty TEXT NOT NULL DEFAULT 'a_verifier',
                created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (person_id) REFERENCES persons(id) ON DELETE CASCADE,
                FOREIGN KEY (customary_name_id) REFERENCES customary_names(id)
            );

-- table: person_group_links
CREATE TABLE person_group_links (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                person_id INTEGER NOT NULL,
                group_id INTEGER NOT NULL,
                link_type TEXT NOT NULL DEFAULT 'rattache_a',
                comment TEXT,
                confidentiality TEXT NOT NULL DEFAULT 'familial',
                certainty TEXT NOT NULL DEFAULT 'a_verifier',
                created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (person_id) REFERENCES persons(id) ON DELETE CASCADE,
                FOREIGN KEY (group_id) REFERENCES customary_groups(id)
            );

-- table: persons
CREATE TABLE persons (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                first_names TEXT NOT NULL,
                current_name TEXT NOT NULL,
                birth_name TEXT,
                other_names TEXT,
                gender TEXT,
                birth_date TEXT,
                birth_place TEXT,
                death_date TEXT,
                current_clan_id INTEGER,
                origin_clan_id INTEGER,
                notes TEXT,
                confidentiality TEXT NOT NULL DEFAULT 'familial',
                certainty TEXT NOT NULL DEFAULT 'a_verifier',
                created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (current_clan_id) REFERENCES clans(id),
                FOREIGN KEY (origin_clan_id) REFERENCES clans(id)
            );

-- table: relationships
CREATE TABLE relationships (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                subject_person_id INTEGER NOT NULL,
                object_person_id INTEGER,
                object_clan_id INTEGER,
                relation_type TEXT NOT NULL,
                comment TEXT,
                confidentiality TEXT NOT NULL DEFAULT 'familial',
                certainty TEXT NOT NULL DEFAULT 'a_verifier',
                created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (subject_person_id) REFERENCES persons(id),
                FOREIGN KEY (object_person_id) REFERENCES persons(id),
                FOREIGN KEY (object_clan_id) REFERENCES clans(id)
            );

-- table: research_items
CREATE TABLE research_items (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                subject_type TEXT NOT NULL,
                subject_id INTEGER,
                title TEXT NOT NULL,
                statement TEXT NOT NULL,
                interpretation TEXT,
                author_view TEXT,
                source_id INTEGER,
                evidence_level TEXT NOT NULL DEFAULT 'document_ecrit',
                confidentiality TEXT NOT NULL DEFAULT 'familial',
                certainty TEXT NOT NULL DEFAULT 'a_verifier',
                created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (source_id) REFERENCES sources(id)
            );

-- table: sources
CREATE TABLE sources (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                source_type TEXT NOT NULL,
                title TEXT NOT NULL,
                witness_name TEXT,
                collection_date TEXT,
                collected_by TEXT,
                summary TEXT NOT NULL,
                consent TEXT NOT NULL DEFAULT 'a_confirmer',
                confidentiality TEXT NOT NULL DEFAULT 'familial',
                reliability TEXT NOT NULL DEFAULT 'a_verifier',
                created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
            );

-- table: users
CREATE TABLE users (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                username TEXT NOT NULL UNIQUE,
                password_hash TEXT NOT NULL,
                created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
            );

-- table: viva_entries
CREATE TABLE viva_entries (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                viva_list_id INTEGER NOT NULL,
                position INTEGER,
                section_name TEXT,
                raw_text TEXT NOT NULL,
                group_a_id INTEGER,
                group_b_id INTEGER,
                translation TEXT,
                note TEXT,
                confidentiality TEXT NOT NULL DEFAULT 'familial',
                certainty TEXT NOT NULL DEFAULT 'a_verifier',
                created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (viva_list_id) REFERENCES viva_lists(id) ON DELETE CASCADE,
                FOREIGN KEY (group_a_id) REFERENCES customary_groups(id),
                FOREIGN KEY (group_b_id) REFERENCES customary_groups(id)
            );

-- table: viva_lists
CREATE TABLE viva_lists (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                title TEXT NOT NULL,
                area TEXT,
                collector_author TEXT,
                collection_date TEXT,
                description TEXT,
                source_id INTEGER,
                confidentiality TEXT NOT NULL DEFAULT 'familial',
                certainty TEXT NOT NULL DEFAULT 'a_verifier',
                created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (source_id) REFERENCES sources(id)
            );
