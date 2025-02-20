## Plots of probabilities of classification
## Needs to have run:
## R CMD BATCH "--args SAISON NMOD JOBID" ${HOME}/programmes/RStat/CMIP6class/CMIP6_tensorflow-classif_v1.R
## for the four seasons
## Pascal Yiou (LSCE), Jan. 2025, Feb. 2025
## Need to: module load R/4.4.1
## Se lance par:
## R CMD BATCH "--args NMOD JOBID" ${HOME}/programmes/RStat/CMIP6class/CMIP6_classif_plots.R
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
l.accur=list()
for(seas in l.seas){
    fname=paste("test_CMIP-class_v1_",nmod,"_",seas,"_",jobid,sep="")
    load(paste(fname,".Rdat",sep=""))
    l.accur[[seas]]=l.OK
}

fout=paste("test_CMIP-class_v1_",jobid,".pdf",sep="")
pdf(file=fout,width=10,height=10)
seas="JJA"
i=1
layout(matrix(1:4,2,2))
for(seas in l.seas){
    par(mar=c(9,4,1,1))
    boxplot(l.accur[[seas]],ylab="Prob. success",xlab="",
            main=paste("(",letters[i],") ",seas,sep=""),
            axes=FALSE,ylim=c(0.0,1))
    axis(side=2)
    axis(side=1,at=c(1:length(l.names)),l.names,las=2)
    abline(h=c(0.6,1/17),lty="dashed",col="grey")
    box()
    i=i+1
}
dev.off()
##legend("bottomleft",bty="n",paste("(",letters[i],") ",seas,sep=""))



q("no")
