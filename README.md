# E-Commerce Backend — DevOps Portfolio Project

REST API e-commerce basée sur **Spring Boot**, containerisée avec **Docker**, déployée via **GitHub Actions**, avec **observabilité** Prometheus/Grafana.

Fork enrichi du projet [ECommerce-SpringBoot-Backend-Project](https://github.com/abinashpanigrahi/ECommerce-SpringBoot-Backend-Project) avec une chaîne DevOps complète.

## Demo

| Service | URL |
|---------|-----|
| API Swagger | http://localhost:8009/swagger-ui/index.html |
| Health | http://localhost:8009/actuator/health |
| Prometheus metrics | http://localhost:8009/actuator/prometheus |
| Prometheus UI | http://localhost:9090 |
| Grafana | http://localhost:3000 |

**Grafana :** `admin` / `admin`

## Architecture

```text
                    ┌─────────────────┐
                    │  GitHub Actions │
                    │  test → build   │
                    │  trivy → GHCR   │
                    └────────┬────────┘
                             │
┌──────────────┐    ┌────────▼────────┐    ┌──────────────┐
│   Grafana    │◀───│   Prometheus    │◀───│   Backend    │
│   :3000      │    │   :9090         │    │ Spring Boot  │
└──────────────┘    └─────────────────┘    │   :8009      │
                                           └──────┬───────┘
                                                  │
                                           ┌──────▼───────┐
                                           │   MySQL 8    │
                                           │   :3307      │
                                           └──────────────┘
```

## Stack

| Couche | Technologies |
|--------|--------------|
| Backend | Java, Spring Boot 2.7, Spring Data JPA, Swagger |
| Database | MySQL 8 |
| Containers | Docker, Docker Compose |
| CI/CD | GitHub Actions, GHCR, Trivy |
| Monitoring | Spring Actuator, Micrometer, Prometheus, Grafana |

## Fonctionnalités API

- Authentification customer / seller (session token)
- CRUD produits, panier, commandes
- Validation métier et gestion d'erreurs

## Démarrage rapide (Docker Compose)

### Prérequis

- Docker + Docker Compose
- ~5 Go d'espace disque libre

### Lancer toute la stack

```bash
git clone https://github.com/MohammedELouaqqad/ecommerce-backend-devops.git
cd ecommerce-backend-devops

docker compose up --build -d
```

### Vérifier les services

```bash
docker compose ps
```

```bash
curl http://localhost:8009/actuator/health
curl http://localhost:8009/products
```

### Arrêter

```bash
docker compose down
```

## Développement local (sans Docker pour l'app)

### Prérequis

- Java 17+
- MySQL sur le port `3307` (ou via Docker)

```bash
docker run -d --name mysql-ecommerce \
  -e MYSQL_ROOT_PASSWORD=root \
  -e MYSQL_DATABASE=ecommercedb \
  -p 3307:3306 mysql:8
```

```bash
./mvnw spring-boot:run
```

## CI/CD Pipeline

Déclenché sur chaque push / pull request vers `main`.

```text
push / PR
   │
   ├─ Job: test
   │    ├─ MySQL 8 (service container)
   │    └─ mvn test
   │
   └─ Job: build-scan-push (push main only)
        ├─ docker build
        ├─ trivy scan (HIGH/CRITICAL)
        └─ push → ghcr.io/mohammedelouaqqad/ecommerce-backend-devops
```

**Image Docker :**

```text
ghcr.io/mohammedelouaqqad/ecommerce-backend-devops:latest
```

## Monitoring & alertes

### Métriques exposées

Le backend expose les endpoints Actuator :

- `/actuator/health`
- `/actuator/prometheus`
- `/actuator/metrics`

### Dashboard Grafana

Import automatique : dossier **ECommerce** → dashboard **ECommerce Backend**

Panels inclus :

- HTTP request rate
- HTTP 5xx errors
- Latency p95
- JVM heap memory

### Alertes Prometheus

Fichier : `monitoring/prometheus/alerts.yml`

| Alerte | Condition |
|--------|-----------|
| `HighErrorRate` | > 5% de réponses 5xx pendant 5 min |
| `HighLatency` | p95 > 1 seconde pendant 5 min |
| `BackendDown` | target Prometheus inaccessible |

Voir les alertes : http://localhost:9090/alerts

## Structure du projet

```text
.
├── .github/workflows/ci-cd.yml
├── Dockerfile
├── docker-compose.yml
├── monitoring/
│   ├── prometheus/
│   │   ├── prometheus.yml
│   │   └── alerts.yml
│   └── grafana/
│       ├── dashboards/
│       └── provisioning/
├── src/
│   ├── main/java/com/masai/
│   └── main/resources/
│       ├── application.properties
│       ├── application-docker.properties
│       └── application-test.properties
└── pom.xml
```

## Endpoints utiles

| Méthode | Endpoint | Description |
|---------|----------|-------------|
| POST | `/register/customer` | Inscription client |
| POST | `/login/customer` | Connexion client |
| GET | `/products` | Liste des produits |
| GET | `/cart` | Panier (session requise) |
| POST | `/order/place` | Passer commande |

Documentation complète : Swagger UI.

## Tests

```bash
./mvnw clean test -B
```

Les tests CI utilisent le profil `test` avec MySQL (service container GitHub Actions).

## Prochaines étapes

- [ ] Deploy automatique sur EC2 ou Kubernetes
- [ ] Terraform pour l'infrastructure
- [ ] Simulation d'incident + post-mortem
- [ ] Pull Request vers le repo original

## Auteur

**Mohammed ELouaqqad**

- GitHub : [@MohammedELouaqqad](https://github.com/MohammedELouaqqad)
- Repo : [ecommerce-backend-devops](https://github.com/MohammedELouaqqad/ecommerce-backend-devops)

## Licence

Projet original sous licence MIT. Les ajouts DevOps sont documentés dans ce fork.
