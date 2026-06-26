# E-Commerce Backend API

REST API e-commerce **Spring Boot**, containerisée avec **Docker**, pipeline **GitHub Actions**, registry **GHCR**, monitoring **Prometheus/Grafana**, déployable sur **AWS EC2**.

Basé sur [ECommerce-SpringBoot-Backend-Project](https://github.com/abinashpanigrahi/ECommerce-SpringBoot-Backend-Project) avec une couche DevOps (Docker, CI/CD, observabilité).

---

## Fonctionnalités DevOps

| Fonctionnalité | Fichier / outil |
|----------------|-----------------|
| Containerisation | `Dockerfile`, `.dockerignore` |
| Orchestration locale | `docker-compose.yml` |
| CI/CD | `.github/workflows/ci-cd.yml` |
| Scan sécurité | Trivy (HIGH/CRITICAL) |
| Registry | GHCR |
| Observabilité | Actuator, Prometheus, Grafana |
| Profils Spring | `application-docker.properties`, `application-test.properties` |
| Deploy cloud | AWS EC2 (`docs/DEPLOYMENT.md`) |

---

## Architecture

```text
                         ┌──────────────────────┐
                         │    GitHub Actions    │
                         │  test → build → push │
                         │       + Trivy        │
                         └──────────┬───────────┘
                                    │
                                    ▼
                         ┌──────────────────────┐
                         │  GHCR Docker Image   │
                         └──────────┬───────────┘
                                    │
          ┌─────────────────────────┼─────────────────────────┐
          │                         │                         │
          ▼                         ▼                         ▼
   Local / EC2                Prometheus (opt.)           Grafana (opt.)
   docker compose                  :9090                      :3000
          │
   ┌──────┴──────┐
   │   Backend   │ :8009  ← Swagger, API, Actuator
   └──────┬──────┘
          │
   ┌──────▼──────┐
   │   MySQL 8   │ :3307 (host) / mysql:3306 (réseau Docker)
   └─────────────┘
```

---

## Stack technique

| Couche | Technologies |
|--------|--------------|
| Backend | Java 17, Spring Boot 2.7, Spring Data JPA, Swagger |
| Base de données | MySQL 8 |
| Conteneurs | Docker, Docker Compose |
| CI/CD | GitHub Actions, GHCR, Trivy |
| Monitoring | Actuator, Micrometer, Prometheus, Grafana |
| Cloud | AWS EC2, Security Groups |

---

## Démarrage rapide

### Prérequis

- Docker + Docker Compose v2
- ~3 Go d'espace disque libre (stack minimale)
- ~5 Go avec monitoring

### Stack minimale (backend + MySQL)

```bash
git clone https://github.com/MohammedELouaqqad/ecommerce-backend-devops.git
cd ecommerce-backend-devops

docker compose up --build -d
```

### Stack complète (+ Prometheus + Grafana)

```bash
docker compose --profile monitoring up --build -d
```

### Vérification

```bash
docker compose ps
curl http://localhost:8009/actuator/health
curl http://localhost:8009/products
```

### URLs locales

| Service | URL | Identifiants |
|---------|-----|--------------|
| Swagger | http://localhost:8009/swagger-ui/index.html | — |
| Health | http://localhost:8009/actuator/health | — |
| Métriques | http://localhost:8009/actuator/prometheus | — |
| Prometheus | http://localhost:9090 | — |
| Grafana | http://localhost:3000 | `admin` / `admin` |

### Arrêter et nettoyer

```bash
docker compose down
docker compose --profile monitoring down -v
```

---

## CI/CD

Pipeline déclenché sur **push** et **pull request** vers `main`.

```text
push / PR
   │
   ├─ Job: test
   │    ├─ MySQL 8 (service container)
   │    └─ ./mvnw test (profil test)
   │
   └─ Job: build-scan-push (push main uniquement)
        ├─ docker build
        ├─ trivy scan (HIGH/CRITICAL)
        └─ push image → GHCR
```

---

## Monitoring

### Actuator

- `/actuator/health`
- `/actuator/prometheus`
- `/actuator/metrics`

### Grafana

Dashboard : dossier **ECommerce** → **ECommerce Backend**

### Alertes Prometheus

Fichier : `monitoring/prometheus/alerts.yml`

| Alerte | Condition |
|--------|-----------|
| `HighErrorRate` | > 5 % de réponses 5xx pendant 5 min |
| `HighLatency` | p95 > 1 s pendant 5 min |
| `BackendDown` | scrape Actuator impossible |

---

## Déploiement AWS EC2

Guide : **[docs/DEPLOYMENT.md](docs/DEPLOYMENT.md)**

1. Ubuntu 24.04 LTS, `t3.small` ou `t3.medium`
2. Security Group : SSH `22` (My IP) + TCP `8009` (API)
3. `git clone` + `docker compose up -d --build mysql backend`
4. Swagger : `http://IP_PUBLIQUE:8009/swagger-ui/index.html`

---

## Développement local (sans Docker pour l'app)

```bash
docker run -d --name mysql-ecommerce \
  -e MYSQL_ROOT_PASSWORD=root \
  -e MYSQL_DATABASE=ecommercedb \
  -p 3307:3306 mysql:8

./mvnw spring-boot:run
```

---

## Tests

```bash
./mvnw clean test -B
```

Profil `test` : `src/main/resources/application-test.properties`

---

## Structure du projet

```text
.
├── .github/workflows/ci-cd.yml
├── Dockerfile
├── docker-compose.yml
├── docs/
│   ├── DEPLOYMENT.md
│   └── POST_MORTEM_TEMPLATE.md
├── monitoring/
├── src/main/resources/
└── pom.xml
```

---

## API (aperçu)

| Méthode | Endpoint | Description |
|---------|----------|-------------|
| POST | `/register/customer` | Inscription client |
| POST | `/login/customer` | Connexion client |
| GET | `/products` | Liste des produits |
| GET | `/cart` | Panier (session requise) |
| POST | `/order/place` | Passer commande |

Documentation complète : Swagger UI.

---

## Remerciements

Projet API original : [abinashpanigrahi/ECommerce-SpringBoot-Backend-Project](https://github.com/abinashpanigrahi/ECommerce-SpringBoot-Backend-Project).

## Licence

MIT (projet original). Les ajouts DevOps suivent la même licence.
