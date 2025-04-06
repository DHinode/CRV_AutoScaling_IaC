# CRV_AutoScaling_IaC


Ce projet consiste à déployer une application web (frontend React + backend Node.js + Redis) sur un cluster Kubernetes en local avec Minikube. Il inclut la mise en place de l'autoscaling des pods selon l'utilisation CPU ainsi qu'un monitoring via Prometheus et Grafana.

---

## Auteurs

- Emilie LIN 21105099
- Maximilien PIRON PALLISER 21107603

## Prérequis 

Installation de :
- [docker](https://developer.fedoraproject.org/tools/docker/docker-installation.html) (si vous voulez rebuild l'image)
- [minikube](https://minikube.sigs.k8s.io/docs/start/?arch=%2Flinux%2Fx86-64%2Fstable%2Fbinary+download) 
- [kubernetes : kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)

## Déploiement 

Déploiement complet : 
```bash
# chmod +x ./script.sh
./script.sh
```

Ce script déploie automatiquement toute notre infrastructure Kubernetes. Il vérifie que Minikube est bien démarré, configure les ressources nécessaires (frontend, backend, base de données), active l’autoscaling des pods (HPA) en fonction de la charge CPU, et met en place la stack de monitoring Prometheus + Grafana.
Il inclut également des options utiles pour nettoyer les ressources, consulter les logs, afficher l’état du cluster ou accéder au dashboard Minikube. 
> Voir comment utiliser les **options** : `./script.sh --help`

### ⚠️ Attention

À noter que le script et toute l'infrastructure sont un peu longs à lancer, si vous apercevez que ça n'affiche pas le bon résultat, attendez un peu et rafraichissez la page du service auquel vous accédez.

## Dockerfile 

Nous avons utilisé nos propres images faites à partir des sources fournies lors du TME. Il n'est donc pas nécessaire de réaliser les opérations décrites ci-dessous. Nous avons ajouté cette sous-section uniquement pour décrire la démarche suivie.

En ce qui concerne les Dockerfile, il faudrait modifier le chemin, à l'intérieur du Dockerfile, selon où sont les projets `redis-react/` et `redis-node/` (dans notre cas les Dockerfile étaient dans les répertoires des projets respectifs).   
Nous buildons les fichiers de cette manière : `docker build -f <CHEMIN_VERS_DOCKERFILE> -t <NOM_UTILISATEUR>/<NOM_IMAGE>:<TAG> <CONTEXTE>` avec `<CONTEXTE>` étant le répertoire où se trouve les fichiers sources.  
Une fois le build terminé, nous pouvons pousser notre image sur Dockerhub avec : `docker push <NOM_UTILISATEUR>/<NOM_IMAGE>:<TAG>`   
**NE PAS OUBLIER DE MODIFIER L'URL DU FICHIER `redis-react/src/conf.js` :** `export const URL = process.env.REACT_APP_API_URL;`  



## Accès aux interfaces 

- Frontend : `http://$(minikube ip):30080`

- Prometheus : `http://$(minikube ip):30090`

- Grafana : `http://$(minikube ip):30030`
    > ⚠️ Login par défaut : admin / admin

Vous pouvez également lancer la commande suivante pour obtenir les URL aux différentes interfaces : `minikube service <nom> --url`

## Tests AutoScaling

__Option 1 (recommandée) :__  
Voir si les HPA scale correctement quand la charge monte : `watch kubectl get hpa`  
Ensuite, dans un autre terminal, lancer : `while true; do curl http://$(minikube ip):30165/items; done`  
Il faudra potentiellement modifié le champs `averageUtilization` utilisé dans les fichiers `k8s/backend-hpa.yml` et `k8s/db-replica-hpa.yml` afin de voir un changement significatif.  


__Option 2 :__  
Lancer : `./script.sh --test-hpa`

## Crédits 

- [arthurescriou](https://github.com/arthurescriou) : [frontend](https://github.com/arthurescriou/redis-react) et [serveur](https://github.com/arthurescriou/redis-node). 
