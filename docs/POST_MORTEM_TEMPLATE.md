# Post-mortem : [titre de l'incident]

**Date :** YYYY-MM-DD  
**Durée de l'incident :** X minutes  
**Impact :** API indisponible / erreurs 5xx / latence élevée

---

## Résumé

Une phrase décrivant ce qui s'est passé et l'impact utilisateur.

---

## Timeline

| Heure (UTC) | Événement |
|-------------|-----------|
| HH:MM | Alerte `BackendDown` ou première erreur observée |
| HH:MM | Investigation (logs, `docker compose ps`, Grafana) |
| HH:MM | Cause identifiée |
| HH:MM | Mitigation appliquée |
| HH:MM | Service rétabli |

---

## Cause racine

Description technique de la cause (ex. conteneur backend arrêté, MySQL inaccessible, manque de RAM).

---

## Détection

Comment l'incident a été détecté :

- [ ] Grafana / Prometheus alert
- [ ] Test manuel (`curl /actuator/health`)
- [ ] Utilisateur / testeur
- [ ] CI/CD

---

## Résolution

Commandes ou actions utilisées :

```bash
docker compose ps
docker compose logs backend --tail 50
docker compose restart backend
```

---

## Ce qui a bien fonctionné

- Ex. healthcheck Docker, logs structurés, documentation deploy

---

## Ce qui peut s'améliorer

- Ex. alertes Slack, deploy auto, plus de RAM sur EC2

---

## Actions correctives

- [ ] Action 1 (responsable, date cible)
- [ ] Action 2
- [ ] Action 3

---

## Scénario de simulation (exercice)

Pour reproduire l'incident en local ou sur EC2 :

```bash
# Simuler panne backend
docker stop ecommerce-backend

# Observer
curl http://localhost:8009/actuator/health

# Restaurer
docker start ecommerce-backend
```
