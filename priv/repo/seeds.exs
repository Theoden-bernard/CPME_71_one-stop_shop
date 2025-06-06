# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ServiceDesk.Repo.insert!(%ServiceDesk.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

if Mix.env() == :dev do
  [
    "développement", "programmation", "codage", "développeur", "programmeur",
    "logiciel", "application", "framework", "bibliothèque", "API",
    "frontend", "backend", "fullstack", "mobile", "web",
    "desktop", "debugging", "testing", "intégration", "déploiement",
    "versioning", "git", "agile", "scrum", "sprint",
    "javascript", "python", "java", "csharp", "php",
    "ruby", "golang", "rust", "typescript", "html",
    "css", "react", "angular", "vue", "nodejs",
    "docker", "kubernetes", "microservices", "cloud", "aws",
    "database", "sql", "nosql", "mongodb", "postgresql",
    "mysql", "redis", "elasticsearch", "serveur", "infrastructure",
    "réseau", "sécurité", "firewall", "backup", "monitoring",
    "projet", "gestion", "planning", "deadline", "livraison",
    "client", "cahier", "spécifications", "requirements", "documentation",
    "design", "interface", "utilisateur", "expérience", "ergonomie",
    "prototype", "maquette", "wireframe", "responsive", "accessibilité",
    "qualité", "test", "unitaire", "intégration", "performance",
    "optimisation", "refactoring", "maintenance",
    "support", "assistance", "formation", "documentation", "tutoriel",
    "helpdesk", "ticketing",
    "intelligence", "artificielle", "machine", "learning", "innovation"
  ]
  |> Enum.map(&ServiceDesk.Tags.create_tag(%{name: &1}))
end  

  
  
