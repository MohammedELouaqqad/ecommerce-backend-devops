# Proposer une contribution au projet original

Ce guide explique comment soumettre une Pull Request au repository upstream :

**https://github.com/abinashpanigrahi/ECommerce-SpringBoot-Backend-Project**

---

## Fichiers ajoutés dans ce fork (à proposer en PR)

| Fichier | Description |
|---------|-------------|
| `Dockerfile` | Build multi-stage Spring Boot |
| `.dockerignore` | Optimisation build Docker |
| `docker-compose.yml` | MySQL + backend (+ monitoring optionnel) |
| `.github/workflows/ci-cd.yml` | Pipeline test, build, Trivy, GHCR |
| `application-docker.properties` | Config Spring pour Docker |
| `application-test.properties` | Config tests CI |
| `monitoring/` | Prometheus + Grafana |
| `pom.xml` | Actuator + Micrometer |
| `docs/` | Documentation DevOps |

---

## Étapes pour créer la PR

### 1. Fork le repo original

1. Ouvrir [abinashpanigrahi/ECommerce-SpringBoot-Backend-Project](https://github.com/abinashpanigrahi/ECommerce-SpringBoot-Backend-Project)
2. Cliquer **Fork**

### 2. Cloner votre fork

```bash
git clone https://github.com/VOTRE_USERNAME/ECommerce-SpringBoot-Backend-Project.git
cd ECommerce-SpringBoot-Backend-Project
```

### 3. Créer une branche

```bash
git checkout -b feature/devops-docker-cicd-monitoring
```

### 4. Copier les fichiers DevOps

Le repo original a le code dans `E-Commerce-Backend/`. Copiez depuis votre fork :

```bash
# Depuis votre machine, adapter le chemin source
cp -r ~/Downloads/ECommerce-SpringBoot-Backend-Project-main/E-Commerce-Backend/Dockerfile \
      ~/Downloads/ECommerce-SpringBoot-Backend-Project-main/E-Commerce-Backend/.dockerignore \
      ~/Downloads/ECommerce-SpringBoot-Backend-Project-main/E-Commerce-Backend/docker-compose.yml \
      E-Commerce-Backend/

cp -r ~/Downloads/ECommerce-SpringBoot-Backend-Project-main/E-Commerce-Backend/.github \
      E-Commerce-Backend/

cp -r ~/Downloads/ECommerce-SpringBoot-Backend-Project-main/E-Commerce-Backend/monitoring \
      E-Commerce-Backend/

cp -r ~/Downloads/ECommerce-SpringBoot-Backend-Project-main/E-Commerce-Backend/docs \
      E-Commerce-Backend/
```

Mettre à jour manuellement :

- `E-Commerce-Backend/pom.xml` (dépendances Actuator)
- `E-Commerce-Backend/src/main/resources/application-docker.properties`
- `E-Commerce-Backend/src/main/resources/application-test.properties`
- `E-Commerce-Backend/src/test/java/com/masai/ECommerceBackendApplicationTests.java` (`@ActiveProfiles("test")`)

### 5. Commit et push

```bash
git add E-Commerce-Backend/
git commit -m "Add Docker, CI/CD, monitoring and deployment documentation"
git push -u origin feature/devops-docker-cicd-monitoring
```

### 6. Ouvrir la Pull Request

Sur GitHub → votre fork → **Compare & pull request**

---

## Modèle de description PR

Copier-coller et adapter :

```markdown
## Summary

This PR adds production-ready DevOps tooling to the E-Commerce Spring Boot backend:

- Multi-stage Dockerfile for containerized deployment
- docker-compose.yml (MySQL + backend, optional Prometheus/Grafana via profile)
- GitHub Actions CI/CD pipeline (Maven tests, Docker build, Trivy scan, GHCR push)
- Spring Boot Actuator + Prometheus metrics + Grafana dashboards
- Spring profiles for Docker and CI test environments
- Deployment documentation (AWS EC2)

## Motivation

Enable developers to run, test, deploy and monitor the API using industry-standard DevOps practices without changing core business logic.

## Test plan

- [ ] `./mvnw clean test -B` passes locally
- [ ] `docker compose up --build -d` starts backend + MySQL
- [ ] Swagger accessible at http://localhost:8009/swagger-ui/index.html
- [ ] `/actuator/health` returns UP
- [ ] GitHub Actions workflow passes on PR
- [ ] `docker compose --profile monitoring up -d` starts Prometheus/Grafana

## Notes

- Monitoring services use Docker Compose profile `monitoring` (optional, not started by default)
- CI uses MySQL service container with `application-test.properties`
- Original API behavior unchanged; only DevOps infrastructure added
```

---

## Après la PR

| Statut | Signification |
|--------|---------------|
| **Open** | En attente de review |
| **Merged** | Contribution acceptée — visible sur votre profil GitHub |
| **Closed** | Refusée ou abandonnée — votre fork reste valide pour portfolio |

Les mainteneurs peuvent demander des modifications. Répondez poliment et poussez des commits sur la même branche.

---

## Si la PR n'est pas acceptée

Votre repo [ecommerce-backend-devops](https://github.com/MohammedELouaqqad/ecommerce-backend-devops) reste un **portfolio DevOps complet** et peut être épinglé sur votre profil GitHub.

---

## Checklist avant PR

- [ ] Tests Maven passent
- [ ] Pas de secrets dans le code (`.env`, tokens, `.pem`)
- [ ] README mis à jour dans `E-Commerce-Backend/` ou racine du repo upstream
- [ ] Commit messages clairs
- [ ] Une PR = un sujet (DevOps infrastructure)
