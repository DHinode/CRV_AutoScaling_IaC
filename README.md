# CRV_AutoScaling_IaC

Note au cas où je me réveille pas pour Max : 

`./script.sh --help` pour en savoir plus
sinon `./script.sh` pour juste lancer tout le truc 

A noter que le script et toute l'infra est un peu long à lancer, si vous apercevez que ça n'affiche pas le bon résultat, attendez un peu et rafraichissez la page du frontend. Sinon je sais pas et franchement je crois que je vais pas me réveiller vu l'heure qu'il est. 


En ce qui concerne les Dockerfile, il faudrait modifier le chemin selon où sont les projets redis-react/ et redis-node/

Je crois que c'est tout s'il y a des erreurs c'est surement dû au mauvais chemin de répertoire. 

---

## Auteurs

- Emilie LIN 21105099
- Maximilien PIRON PALLISER 21107603

## Prérequis 

Installation de [docker](https://developer.fedoraproject.org/tools/docker/docker-installation.html) (si vous voulez rebuild l'image), [kubernetes](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/), [minikube](https://minikube.sigs.k8s.io/docs/start/?arch=%2Flinux%2Fx86-64%2Fstable%2Fbinary+download), ainsi que node.js (et yarn) et reactjs.

## Deploiment 

```bash
chmod +x ./script.sh
./script.sh
```

### Options inclus dans le script 

Voir : `./script.sh --help`

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
