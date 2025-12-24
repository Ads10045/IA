# Visite Technique - Backend Installation

Ce dossier contient les éléments nécessaires pour déployer l'API Backend.

## Contenu
- `visite-technique.jar` : L'application Spring Boot exécutable.
- `database_export.sql` : Export complet de la base de données PostgreSQL.

## Prérequis
- Java 21 ou supérieur installé.
- PostgreSQL 17 installé et en cours d'exécution.

## Installation de la Base de Données
1. Créez une base de données nommée `visite_technique` dans PostgreSQL.
2. Importez le fichier SQL :
   ```bash
   psql -U postgres -d visite_technique -f database_export.sql
   ```

## Lancement de l'Application
Lancez le JAR avec la commande suivante :
```bash
java -jar visite-technique.jar
```
L'application sera accessible sur `http://localhost:8085`.

## Documentation API
Une fois lancée, la documentation Swagger est disponible sur :
`http://localhost:8085/swagger-ui.html`
