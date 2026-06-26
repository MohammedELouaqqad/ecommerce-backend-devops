# Guide de déploiement AWS EC2

Ce document décrit le déploiement de la stack **backend + MySQL** sur une instance EC2.

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

## 4. Déployer l'application

```bash
git clone https://github.com/<OWNER>/ecommerce-backend-devops.git
cd ecommerce-backend-devops

docker compose up -d --build mysql backend
```

Sur `t3.small`, ne déployer que `mysql` et `backend` (pas Prometheus/Grafana).

---

## 5. Vérifier

```bash
docker compose ps
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

Remplacer le service `backend` dans `docker-compose.yml` :

```yaml
backend:
  image: ghcr.io/<OWNER>/ecommerce-backend-devops:latest
  # supprimer la section build:
```

```bash
docker compose pull backend
docker compose up -d mysql backend
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
docker compose up -d mysql backend
```

---

## Dépannage

| Problème | Solution |
|----------|----------|
| SSH timeout | Security Group : port 22 ouvert pour My IP |
| API inaccessible | Port 8009 ouvert dans Security Group |
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
