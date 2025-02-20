## Trace des cartes de pression et écart-type pour 16 modèles CMIP6
## et ERA5
## Pascal Yiou, LSCE, Feb 2025

SI=Sys.info()
user=SI[["user"]]
if(SI[[1]] == "Darwin"){
    Rsource=paste("/Users/",user,"/programmes/RStat/",sep="")
    DATdir = paste("/Users/",user,"/work/CMIP6_IA/meanstd/",sep="") ## Needs to be adapted
    OUTdir=paste("/Users/",user,"/work/CMIP6_IA/meanstd/",sep="")  ## Needs to be adapted
}

if(SI[[1]] == "Linux"){
    Rsource=paste("/home/",user,"/programmes/RStat/",sep="")
    DATdir=paste("/scratchx/",user,"/CMIP6/testML",sep="")
    OUTdir = paste("/home/",user,"/RESULTS/",sep="") ## Needs to be adapted
}


library(ncdf4)
library(ncdf4.helpers)
## Pour tracer des cartes de contrôle
source(paste(Rsource,"imagecont.R",sep=""))

setwd(DATdir)
## Liste des modeles à lire
##LIST=scan(file="model-sel_16_ref.txt",what=character())
LIST=c("era5_msl_daily_NAtl_1970-2000",
"psl_BCC_BCC-CSM2-MR_historical_r1i1p1f1_NAtl_1970-2000",
"psl_CAS_FGOALS-g3_historical_r1i1p1f1_NAtl_1970-2000",
"psl_CCCma_CanESM5_historical_r1i1p1f1_NAtl_1970-2000",
"psl_CNRM-CERFACS_CNRM-CM6-1_historical_r1i1p1f2_NAtl_1970-2000",
"psl_CSIRO_ACCESS-ESM1-5_historical_r1i1p1f1_NAtl_1970-2000",
"psl_EC-Earth-Consortium_EC-Earth3_historical_r1i1p1f1_NAtl_1970-2000",
"psl_INM_INM-CM5-0_historical_r1i1p1f1_NAtl_1970-2000",
"psl_IPSL_IPSL-CM6A-LR_historical_r1i1p1f1_NAtl_1970-2000",
"psl_MIROC_MIROC6_historical_r1i1p1f1_NAtl_1970-2000",
"psl_MOHC_HadGEM3-GC31-LL_historical_r1i1p1f3_NAtl_1970-2000",
"psl_MPI-M_MPI-ESM1-2-LR_historical_r1i1p1f1_NAtl_1970-2000",
"psl_MRI_MRI-ESM2-0_historical_r1i1p1f1_NAtl_1970-2000",
"psl_NCAR_CESM2_historical_r1i1p1f1_NAtl_1970-2000",
"psl_NCC_NorCPM1_historical_r1i1p1f1_NAtl_1970-2000",
"psl_NIMS-KMA_KACE-1-0-G_historical_r1i1p1f1_NAtl_1970-2000",
"psl_NUIST_NESM3_historical_r1i1p1f1_NAtl_1970-2000")

season="JJA"
## Lecture des données
SLPdat=list()
i=1
for(i in 1:length(LIST)){
    varname=ifelse(i==1,"msl","psl")
    
    fname=paste(LIST[i],"_",season,"_mean.nc",sep="")
    nc=nc_open(fname)
    SLPmean=ncvar_get(nc,varname)
    lon=ncvar_get(nc,"lon")
    lat=ncvar_get(nc,"lat")
    nc_close(nc)

    fname=paste(LIST[i],"_",season,"_std.nc",sep="")
    nc=nc_open(fname)
    SLPstd=ncvar_get(nc,varname)
    nc_close(nc)
    modname=ifelse(i==1,"ERA5","MOD")
    if(i > 1){
        modname=strsplit(fname,"_")[[1]][3]
    }

    SLPdat[[i]]=list(modname=modname,mean=SLPmean,std=SLPstd,lon=lon,lat=lat)
}

## Tracé de la figure
nfig=paste("maps_SLP_ERA5-CMIP6_",season,".png",sep="")
png(nfig,height=660,width=550)
stdlim=seq(0,10,length=11)
layout(matrix(1:18,6,3))
for(i in 1:length(LIST)){
    image.cont(SLPdat[[i]]$lon,SLPdat[[i]]$lat,SLPdat[[i]]$std,
               xlab="",ylab="",
               zlev=stdlim,satur=TRUE,legend=FALSE,
               transpose=FALSE,mar=c(2,2,1,1))
    image.cont.c(SLPdat[[i]]$lon,SLPdat[[i]]$lat,SLPdat[[i]]$mean,
                 xlab="",ylab="",
                 transpose=FALSE,mar=c(2,2,1,1),add=TRUE)
    legend("topleft",legend=letters[i],bg="white")
    legend("topright",legend=SLPdat[[i]]$modna,bg="white")

}
## Légende
par(mar=c(1,1,1,6))
col10=rainbow(length(stdlim)-1,start=0,end=2/6)
plot(c(0,1),axes=FALSE,xlab="",ylab="",type="n")
image.plot(SLPdat[[i]]$std,col=col10[length(col10):1],
           legend.only=TRUE,zlim=range(stdlim),
##          horizontal=TRUE,mar=c(1,1,1,1),legend.lab="")
##legend("left",bty="n",legend="sigma SLP (hPa)")
           legend="sigma SLP (hPa)",mar=c(1,1,1,8))

#zlim=round(range(Apred),digits=1)
##image.plot(1:nrow(Apred),1:ncol(Apred),t(Apred),axes=FALSE,xlab="",ylab="",
##           zlim=zlim,nlevel=10,col=rev(pal_grey(0, 1)(10)))
dev.off()

q("no")
