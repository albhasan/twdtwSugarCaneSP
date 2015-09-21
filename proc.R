# Rscript for open boundary DTW time series analysis
# Author: Victor Maus
# May 2015


library(dtwSat)
library(parallel)
library(plyr)

# Load temporal patterns
load(LIBRARYPATH)

# Year segments 
years = as.numeric(format(as.Date(FROM), "%Y")):as.numeric(format(as.Date(TO), "%Y"))

# Compute original array indexes
I = unique(drow)
J = unique(dcol)
indexArray = list()
k = 1
for(i in I)
  for(j in J)
  {
    indexArray[[k]] = c(j=j, i=i)
    k = k + 1
  }

devi[devi < 0] = NA
Y = devi / 10000
TY = recoverMODISDates(years, frequency=16)[ dtime+1 ]


out = mclapply(indexArray, mc.silent = TRUE,
      mc.cores = getOption("mc.cores", NCORES), function(p){
        # Select time series
        idx = which(dcol==p["j"] & drow==p["i"])
        if(length(idx)<2)
           return(NULL)

        # Step 1. TS SMOOTHING
        y = Y[idx]
        ty = TY[idx]
        template = try(timeSeriesSmoothing(ty, y, ty, method=c("wavelet",1)))
        if(class(template)=="try-error")
           return(NULL)

        # Step 2. DTW ANALYSES FOR EACH PATTERN
        dtw_results = lapply(query.list, function(query){
                        out = try(timeSeriesAnalysis2(query, template, method=METHOD, threshold=THRESHOLD, normalize=NORMALIZE,
                                                  delay=DELAY, theta=THETA, alpha=ALPHA, beta=BETA))
                        if(class(out)=="try-error")
                            return(NULL)
                        return(out)
        })


        # Step 3. BUILD THE INPUT FOR SCIDB ARRAY    
        out = list()
        out$col = rep(p["j"]/1, length(years)-1)
        out$row = rep(p["i"]/1, length(years)-1)
        out$year = years[-1]/1
        res = lapply(dtw_results, function(x){
           unlist(lapply(years[-1], function(y){
               I = which(as.numeric(format(x$to, "%Y"))==y)
               if(length(I)==0)
                 return(FILL/1)
               return(min(x$distance[I])/1)
           }))
        })

        return(c(out, res))
})

# Format output
res = c(ldply(out, data.frame))
if(length(res)!=output_attrs){
   res = list()
   res$col = dcol[1]/1
   res$row = drow[1]/1
   res$year = years[1]/1
   res = c( res, lapply(1:(output_attrs-length(res)), function(...) return(FILL/1)))
}



