Instructions pour la classification de modèles CMIP6 sur la SLP

Par Pascal Yiou (LSCE), Jan. 2025.

Ce document explique la séquence d'instructions à suivre pour faire la
classification de modèles CMIP6 selon des cartes journalières de SLP
autour de l'Atlantique Nord.

Les calculs doivent être conduits sur spiritx ou sur hal (pour la classification).

This document is in French because the scripts work on the (French) IPSL computing server. I guess that they could run on any server, provided that the data are stored in a consistent way.

------------------------------------------------------------------------------
Etape 1 (spiritx)
Préparation des données de SLP à partir de l'archive CMIP6.
Lancer:
sbatch --partition zen4 --ntasks=1 --cpus-per-task=10 --time 60:00:00 ${HOME}/programmes/RStat/CMIP6class/CMIP6-all_psl_file-prepare.sh scenario

où scenario = historical, ssp126, ssp245, ssp370, ssp585

Ce script explore l'archive CMIP6 sur /bdd/ de spiritx. Ca prend ~24h
par scenario IPCC (à cause des instructions cdo, qui ne sont pas très
efficaces). On ne le fait qu'une seule fois. Cela génère le matériau de la classification.

------------------------------------------------------------------------------
Etape 2 (hal ou spiritx)
Determination du nombre de run par modèle.
Lancer:
${HOME}/programmes/RStat/CMIP6class/select_CMIP6-simulations.R

Ce script génère une figure (en quelques secondes). Il peut être
exécuté en intéractif.

------------------------------------------------------------------------------
Etape 3 (hal)
Classification de la SLP pour un ensemble de modèles déterminés par la figure
générée dans l'étape 2. La liste des modèles est écrite "en dur" dans
le script en R.

Lancer:
sbatch ${HOME}/programmes/RStat/CMIP6class/CMIP6_classif-v1.sh NMOD
où NMOD vaut 16 (nombre de modèles "de base")

Cette étape crée une figure par saison (scores de classification de la SLP), un fichier .Rdata avec quelques infos, et un fichier .keras de modèle de classification. Il faut récupérer le No de job (JOBID) à partir des fichiers de sortie (.pdf, Rdata ou .keras)

Une figure récapitulative est créée (.pdf) pour les 4 saisons.

Cette étape prend ~30mn.

------------------------------------------------------------------------------
Etape 4 (hal)
Vérification de la classification sur d'autres runs historical. On calcule la probabilité de classer un modèle XX sur un modèle YY, avec des données qui n'ont pas servi à l'apprentissage.

Lancer:
sbatch ${HOME}/programmes/RStat/CMIP6class/CMIP6_verif-v1.sh NMOD JOBID
où NMOD vaut 16 et JOBID est le No. de job créé dans l'étape 3.

Cette étape crée une figure .pdf par saison (score) et un fichier .Rdata avec les données qui servent à faire la figure. On analyse aussi les conditions de SLP pour lesquelles la classification n'est pas bien faite.

Une figure récapitulative est créée (.pdf) pour les 4 saisons.

L'étape dure ~10mn. Ce qui prend du temps est la lecture des fichiers .nc.

------------------------------------------------------------------------------
Etape 5 (hal)
Classification d'autres modèles CMIP6 que les NMOD=16 choisis dans
l'étape 3. On calcule la probabilité de classer un modèle XX sur un
modèle YY, avec des données qui n'ont pas servi à l'apprentissage.

Lancer:
sbatch ${HOME}/programmes/RStat/CMIP6class/CMIP6_verif-other_v1.sh NMOD JOBID
où NMOD=16 et JOBID est le No. de job créé dans l'étape 3.

Cette étape crée une figure .pdf par saison (score) et un fichier .Rdata avec les données qui servent à faire la figure. On analyse aussi les conditions de SLP pour lesquelles la classification n'est pas bien faite.

Une figure récapitulative est créée (.pdf) pour les 4 saisons.

L'étape dure ~7mn. Ce qui prend du temps est la lecture des fichiers .nc.

------------------------------------------------------------------------------
Etape 6 (hal)
Classification de la SLP de simulations scénarios à partir de l'apprentissage historique. On doit spécifier la période à considérer.

Lancer:
sbatch ${HOME}/programmes/RStat/CMIP6class/CMIP6_verif-scen_v1.sh NMOD SCEN YR1 YR2 JOBID
où NMOD=16, SCEN est le scénario (ssp370 ou ssp585), YR1 et YR2 sont les bornes temporelles, et JOBID est le No. de job de l'étape 3.

Cette étape crée une figure .pdf par saison (score) et un fichier .Rdata avec les données qui servent à faire la figure. On analyse aussi les conditions de SLP pour lesquelles la classification n'est pas bien faite.

On peut faire varier les dates de classifications YR1 et YR2.

Une figure récapitulative est créée (.pdf) pour les 4 saisons.

L'étape dure ~10 mn. Ce qui prend du temps est la lecture des fichiers .nc.


