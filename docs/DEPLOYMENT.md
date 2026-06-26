# Guide de déploiement AWS EC2 (production)

Ce document décrit le déploiement **production** de la stack **backend + MySQL** sur EC2, avec le profil Spring `prod`.

---

## Dev vs Prod dans ce projet

| | **Dev** (`docker-compose.yml`) | **Prod** (`docker-compose.prod.yml`) |
|---|-------------------------------|--------------------------------------|
| Profil Spring | `docker` | `prod` |
| Mots de passe | `root/root` (OK en local) | Variables `.env` (secrets) |
| Schéma DB | Hibernate `update` auto | Flyway migrations + `validate` |
| SQL dans les logs | `show-sql=true` | `show-sql=false` |
| MySQL exposé | Port 3307 (local) | **Non** (réseau Docker uniquement) |
| Health details | `always` | `when_authorized` |

---

## Prérequis

- Compte AWS
- Paire de clés SSH (`.pem`)
- Repository clonable (public ou token GitHub)

---

## 1. Créer l'instance EC2

| Paramètre | Valeur recommandée |
|-----------|-------------------|
| AMI | Ubuntu Server **24.04 LTS** (Canonical, x86) |
| Instance type | `t3.small` (min) ou `t3.medium` (recommandé) |
| Storage | 30 GiB gp3 |
| Key pair | `ecom-key.pem` |
| Public IP | Enable |

### Security Group

| Type | Port | Source |
|------|------|--------|
| SSH | 22 | **My IP** |
| Custom TCP | 8009 | `0.0.0.0/0` (API publique) |

Ne pas exposer MySQL (3306/3307) sur Internet.

---

## 2. Connexion SSH

```bash
chmod 400 ~/Downloads/ecom-key.pem
ssh -i ~/Downloads/ecom-key.pem ubuntu@IP_PUBLIQUE_EC2
```

> Utilisez l'**IP publique EC2** (console AWS), pas votre IP personnelle.

---

## 3. Installer Docker

```bash
sudo apt update
sudo apt install -y docker.io docker-compose-v2 git
sudo usermod -aG docker ubuntu
newgrp docker

docker --version
docker compose version
```

---

## 4. Déployer en production

```bash
git clone https://github.com/MohammedELouaqqad/ecommerce-backend-devops.git
cd ecommerce-backend-devops

# Créer le fichier de secrets (ne jamais le committer)
cp .env.example .env
nano .env   # remplacer MYSQL_ROOT_PASSWORD par un mot de passe fort

# Lancer la stack production
docker compose -f docker-compose.prod.yml --env-file .env up -d --build
```

Au premier démarrage, **Flyway** crée automatiquement le schéma de la base (`V1__initial_schema.sql`).

---

## 5. Vérifier

```bash
docker compose -f docker-compose.prod.yml ps
curl http://localhost:8009/actuator/health
```

Navigateur :

```text
http://IP_PUBLIQUE_EC2:8009/swagger-ui/index.html
```

---

## 6. Utiliser l'image GHCR (optionnel)

```bash
echo $GITHUB_TOKEN | docker login ghcr.io -u <GITHUB_USERNAME> --password-stdin
```

Dans `.env`, décommenter et définir :

```bash
BACKEND_IMAGE=ghcr.io/mohammedelouaqqad/ecommerce-backend-devops:latest
```

Puis :

```bash
docker compose -f docker-compose.prod.yml --env-file .env pull backend
docker compose -f docker-compose.prod.yml --env-file .env up -d
```

---

## 7. Gestion de l'instance

| Action | Console AWS | Effet |
|--------|-------------|-------|
| **Stop** | Instance state → Stop | Pause, données conservées |
| **Start** | Instance state → Start | Redémarrage (IP peut changer) |
| **Terminate** | Instance state → Terminate | Suppression définitive |

Après un **Stop/Start**, vérifier la nouvelle IP publique et relancer :

```bash
cd ~/ecommerce-backend-devops
docker compose -f docker-compose.prod.yml --env-file .env up -d
```

---

## Variables d'environnement (prod)

| Variable | Description |
|----------|-------------|
| `MYSQL_ROOT_PASSWORD` | Mot de passe root MySQL (fort, unique) |
| `MYSQL_DATABASE` | Nom de la base (défaut : `ecommercedb`) |
| `DB_URL` | URL JDBC (défaut dans `.env.example`) |
| `DB_USERNAME` | Utilisateur DB (défaut : `root`) |
| `DB_PASSWORD` | Doit correspondre à `MYSQL_ROOT_PASSWORD` |
| `BACKEND_IMAGE` | Image GHCR (optionnel) |

---

## Dépannage

| Problème | Solution |
|----------|----------|
| SSH timeout | Security Group : port 22 ouvert pour My IP |
| API inaccessible | Port 8009 ouvert dans Security Group |
| `DB_PASSWORD` manquant | Vérifier `.env` et `--env-file .env` |
| Erreur Flyway / validate | Voir les logs : `docker compose -f docker-compose.prod.yml logs backend` |
| Build lent / OOM | Passer à `t3.medium` |
| `git clone` demande mot de passe | Repo privé → token ou SSH deploy key |

---

## Coûts estimés (us-east-1)

| Ressource | Coût indicatif |
|-----------|----------------|
| t3.small 24/7 | ~15 USD/mois |
| t3.medium 24/7 | ~30 USD/mois |
| EBS 30 GiB | ~3 USD/mois |

**Conseil :** arrêter l'instance quand elle n'est pas utilisée.
