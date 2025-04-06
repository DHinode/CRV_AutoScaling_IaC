# CRV_AutoScaling_IaC

[TODO] ajout de petite description  

---

## Auteurs

- Emilie LIN 21105099
- Maximilien PIRON PALLISER 21107603

## Prérequis 

Installation de :
- [docker](https://developer.fedoraproject.org/tools/docker/docker-installation.html) (si vous voulez rebuild l'image)
- [minikube](https://minikube.sigs.k8s.io/docs/start/?arch=%2Flinux%2Fx86-64%2Fstable%2Fbinary+download) 
- [kubernetes : kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)

## Deploiment 

Deploiment complet : 
```bash
# chmod +x ./script.sh
./script.sh
```

### Options inclus dans le script 

Voir : `./script.sh --help`

### ⚠️ Attention

À noter que le script et toute l'infrastructure sont un peu long à lancer, si vous apercevez que ça n'affiche pas le bon résultat, attendez un peu et rafraichissez la page du service auquel vous accédez.

En ce qui concerne les Dockerfile, il faudrait modifier le chemin selon où sont les projets `redis-react/` et `redis-node/`. 
Nous buildons les fichiers de cette manière : `docker build -f <CHEMIN_VERS_DOCKERFILE> -t <NOM_IMAGE>:<TAG> <CONTEXTE>` avec `<CONTEXTE>` étant le répertoire où se trouve les fichiers sources. 

## Accès aux interfaces 

- Frontend : `http://$(minikube ip):30080`

- Prometheus : `http://$(minikube ip):30090`

- Grafana : `http://$(minikube ip):30030`
    > ⚠️ Login par défaut : admin / admin

Vous pouvez également lancer la commande suivante pour obtenir les URL aux différentes interfaces : `minikube service <nom> --url`

## Tests / démonstration

Voir si les HPA scale correctement quand la charge monte : `watch kubectl get hpa`

## Crédits 

- [arthurescriou](https://github.com/arthurescriou) : [frontend](https://github.com/arthurescriou/redis-react) et [serveur](https://github.com/arthurescriou/redis-node). 
