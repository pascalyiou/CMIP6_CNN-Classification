## Attention: v0 de référence. NE PLUS TOUCHER!
## Comptage de simulations historical par modèle CMIP6 dans l'archive /bdd
## sur spiritx
##
## Can we identify a CMIP6 model from one SLP map over the eastern North
## Atlantic?
## Pascal Yiou (LSCE), Oct. 2024, Nov. 2024, Dec. 2024
## Version v0 proche de l'originale.
## C'est celle qui marche le mieux. NE PAS TOUCHER!
## Fonctionne sur la machine GPU hal de l'IPSL
## Se lance par:
## R CMD BATCH ${HOME}/programmes/RStat/CMIP6class/select_CMIP6-simulations.R 

SI=Sys.info()
user=SI[["user"]]
if(SI[[1]] == "Linux"){
    Rsource=paste("/home/",user,"/programmes/RStat/",sep="")
    DATdir=paste("/scratchx/",user,"/CMIP6/testML",sep="")
    ERAdir=paste("/scratchx/",user,"/ERA5/",sep="")
    OUTdir = paste("/home/",user,"/RESULTS/",sep="") ## Needs to be adapted
}
if(SI[[1]] == "Darwin"){
    Rsource=paste("/Users/",user,"/programmes/RStat/",sep="")
    DATdir = paste("/Users/",user,"/work/CMIP6_IA/",sep="") ## Needs to be adapted
    OUTdir=paste("/Users/",user,"/work/CMIP6_IA/",sep="")  ## Needs to be adapted
}

setwd(DATdir)
## Liste des fichiers CMIP6
ls.fi=system("ls psl*1970-2000.nc",intern=TRUE)
dum=strsplit(ls.fi,"_historical_")
adum=t(matrix(unlist(dum),nrow=2))
## Nom des groupes et modèles
dum=t(matrix(unlist(strsplit(adum[,1],"psl_")),nrow=2))
namsim=dum[,2]
## Nom du run du modèle
namrun=unlist(strsplit(adum[,2],"_NAtl_1970-2000.nc"))
## Comptage des simulations par modèle
unamsim=unique(namsim)
countsim= tapply(namsim,namsim,length)
## Liste des modèles avec plus de 2 runs
l.mod2=unamsim[which(countsim >= 2)]

## Modeles à selectionner
l.mod.sel=c("BCC_BCC-CSM2-MR","CAS_FGOALS-g3","CCCma_CanESM5",
            "CNRM-CERFACS_CNRM-CM6-1","CSIRO_ACCESS-ESM1-5",
            "EC-Earth-Consortium_EC-Earth3",
##                 "HAMMOZ-Consortium_MPI-ESM-1-2-HAM",
            "INM_INM-CM5-0","IPSL_IPSL-CM6A-LR","MIROC_MIROC6",
            "MOHC_HadGEM3-GC31-LL",
##            "MOHC_UKESM1-0-LL",
            "MPI-M_MPI-ESM1-2-LR","MRI_MRI-ESM2-0",
            "NCAR_CESM2","NCC_NorCPM1","NIMS-KMA_KACE-1-0-G",
            "NUIST_NESM3")


## Comptage des simulations par modèle
setwd(OUTdir)

dum=t(matrix(unlist(strsplit(names(countsim),"_")),nrow=2))
ndum=dum[,2]
modcol=ifelse(countsim>1,"black","blue")
modcol[names(countsim) %in% l.mod.sel] = "red"
pdf(file="count-sim_CMIP.pdf",width=12)
par(mar=c(10,4,1,1))
plot(countsim,type="h",axes=FALSE,ylab="Nb sim.",xlab="",col=modcol,lwd=3)
axis(side=2)
axis(side=1,at=c(1:length(countsim)),labels=ndum,las=2)
box()
dev.off()

## Creation d'un tableau avec les noms de modeles de référence
## et le nb de simulations
filout="count-sim_CMIP6-ref.txt"
cat(file=filout,paste("Model name & Group name & Nb runs \\\\ \n"))
for(mod in l.mod.sel){
    dum=strsplit(mod,"_")
    cat(file=filout,paste(dum[[1]][2]," &  ",dum[[1]][1]," &  ",
                          countsim[[mod]], "\\\\ \n"),append=TRUE)
}

filout="count-sim_CMIP6-all.txt"
cat(file=filout,paste("Model name & Group name & Nb runs \\\\ \n"))
for(mod in names(countsim)){
    dum=strsplit(mod,"_")
    cat(file=filout,paste(dum[[1]][2]," &  ",dum[[1]][1]," &  ",
                          countsim[[mod]], "\\\\ \n"),append=TRUE)
}



q("no")
