## Plots of probabilities of classification
## Needs to have run:
## R CMD BATCH "--args SAISON NMOD JOBID" ${HOME}/programmes/RStat/CMIP6class/CMIP6_tensorflow-verif_v1.R
## for the four seasons
## Pascal Yiou (LSCE), Jan. 2025
## Need to: module load R/4.4.1
## Se lance par:
## R CMD BATCH "--args NMOD JOBID" ${HOME}/programmes/RStat/CMIP6class/CMIP6_verif_plots.R
##
SI=Sys.info()
user=SI[["user"]]
if(SI[[1]] == "Linux"){
    Rsource=paste("/home/",user,"/programmes/RStat/",sep="")
    DATdir=paste("/scratchx/",user,"/CMIP6/testML",sep="")
    ERAdir=paste("/scratchx/",user,"/ERA5/",sep="")
    OUTdir = paste("/net/nfs/ssd1/",user,"/IA_RESULTS",sep="") ## Needs to be adapted
    Sys.setenv('TAR'='/usr/bin/tar') # Sinon R ne trouve pas le executable tar
    .libPaths(c("/home/pyiou/R/x86_64-pc-linux-gnu-library/4.0", .libPaths()) ) # sinon R met en priorité un libpath sur lequel l'utilisateur n'a pas les droits d'écriture. chemin à modifier avec son propre libpath. 
}

## Pour concaténer des tableaux en 3d
library(abind)
## Pour tracer des cartes de contrôle
library(fields)
library(scales)
source(paste(Rsource,"imagecont.R",sep=""))

## Arguments du programme
args=(commandArgs(TRUE))
print(args)
i=1
if(length(args)>0){
    nmod = as.numeric(args[i]) ;i=i+1 ## Nombre de modeles à prendre
    jobid = args[i] ;i=i+1 ## Indice du job
}else{
    nmod = 16 ## Nombre de modeles à prendre
    jobid = "17608"
}

l.seas=c("JJA","SON","DJF","MAM")

setwd(paste("/net/nfs/ssd1/",user,"/IA_RESULTS",sep=""))
l.Apred=list()
l.info=list()
for(seas in l.seas){
    fname=paste("proba-class-v1_CMIP6_",seas,"_",nmod,"_",jobid,
                sep="")
    load(paste(fname,".Rdata",sep=""))
    l.Apred[[seas]]=Apred
    l.info[[seas]]=list(l.names,l.frun)
}

zlim=round(range(Apred),digits=1)
zlim=c(0,0.8)
col=gray(seq(0, 1, length.out=10))
fout=paste("proba-class-v1_CMIP6_",nmod,"_",jobid,".pdf",
           sep="")
pdf(file=fout,width=10,height=10)
layout(matrix(1:4,2,2))
i=1
for(seas in l.seas){
    par(mar=c(9,10,1,2))
    image.plot(1:nrow(l.Apred[[seas]]),1:ncol(Apred),l.Apred[[seas]],
               axes=FALSE,xlab="",ylab="",
               main=paste("(",letters[i],") ",seas,sep=""),
               zlim=zlim,nlevel=10,col=rev(col))
    axis(side=2,at=1:ncol(l.Apred[[seas]]),labels=l.names,las=2)
    axis(side=1,at=1:nrow(l.Apred[[seas]]),labels=l.names,las=2)
    box()
    i=i+1
}
dev.off()

q("no")
