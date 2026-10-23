# Reglages de verifier-tache.ps1 pour ce projet. Chemins relatifs a la racine du depot ; motifs en expressions
# regulieres (.NET). L'exemple vise un backend Java en couches (src/main/java/com/example/app) et un frontend
# TypeScript : remplacer chemins et motifs par ceux du projet, retirer ce qui ne s'applique pas.
@{
    # Conventions (facultatives, valeurs par defaut ci-dessous) : branche principale et types de commit
    MainBranch        = 'main'
    TestCommitPattern = '^test(\(|:)'
    CodeCommitPattern = '^(feat|fix)(\(|:)'

    # Fichiers de test : jamais modifies dans un commit feat ou fix
    TestPatterns = @(
        '^backend/src/(test|integration-test)/'
        '^frontend/e2e/'
        '\.test\.tsx?$'
    )

    # Code de production : un commit feat ou fix qui le touche doit suivre un commit test(...)
    ProductionPatterns = @(
        '^backend/src/main/.+\.(java|sql)$'
        '^frontend/src/.+\.tsx?$'
    )

    # Migrations du schema (retirer la cle si le projet n'en a pas). NamePattern : le groupe 1 est le numero.
    Migrations = @{
        Dir         = 'backend/src/main/resources/db/migration'
        NamePattern = '^V(\d+)__[a-z0-9_]+\.sql$'
    }

    # Motifs interdits par dossier : Path, Filter, Pattern, Message ; AllowLine et AllowPath facultatifs
    CodeRules = @(
        @{
            Path    = 'backend/src/main/java/com/example/app/domain'
            Filter  = '*.java'
            Pattern = '^import (org\.springframework|java\.sql|javax\.sql|jakarta\.)'
            Message = "Domaine dependant d'un outil"
        }
        @{
            Path      = 'backend/src/main/java/com/example/app/application'
            Filter    = '*.java'
            Pattern   = '^import org\.springframework\.'
            AllowLine = '^import org\.springframework\.(stereotype\.Service|transaction\.annotation\.Transactional);'
            Message   = 'Application dependante du framework'
        }
        @{
            Path    = 'backend/src/main/java/com/example/app/presentation'
            Filter  = '*.java'
            Pattern = '^import com\.example\.app\.infrastructure\.'
            Message = "Presentation dependante de l'infrastructure"
        }
        @{
            Path      = 'backend/src/main/java/com/example/app'
            Filter    = '*.java'
            Pattern   = '(Instant|LocalDateTime|LocalDate|ZonedDateTime|OffsetDateTime)\.now\(\)|Clock\.system'
            AllowPath = 'Application\.java$'
            Message   = 'Horloge non injectee'
        }
    )

    # Changements de stack : signales pour verifier que l'etape Stack a ete validee
    StackPatterns = @(
        '(^|/)(pom\.xml|build\.gradle(\.kts)?|package\.json|package-lock\.json|Dockerfile[^/]*|docker-compose[^/]*\.ya?ml)$'
        '^\.github/workflows/'
    )

    # Liste des choses a faire, cochee au fil des taches (chaine vide pour ne pas verifier)
    TodoFile = 'docs/projet/a-faire.md'

    # Dossier des audits de fin de tache
    AuditDir = 'docs/projet/audits'
}
