# Rscript for open boundary DTW time series analysis within SciDB
# Author: Victor Maus
# May 2015

library(dtwSat)
library(scidb)
library(scales)

# Input parameters
scidbconnect(host = "localhost", user="scidb", password="xxxx.xxxx.xxxx", port = 8083)
INPUTARRAY = "MOD13Q1"
MINCOL = 59354
MAXCOL = 60132
MINROW = 48591
MAXROW = 49096

# Processing parameters
SUBTILESIZECOL = 256
SUBTILESIZEROW = 256
JUNKCOL = 32
JUNKROW = 32
FROM = "2000-02-18"
TO = "2014-10-31"
LIBRARYPATH = "/home/scidb/EMBRAPA++.evi.RData" # Temporla patterns
EXPPRPATH = "/home/scidb/proc.R" # Processing script
NCORES = 6
THRESHOLD = 0.1
FILL = -3000
NORMALIZE = TRUE
REALDAY = TRUE # use the real day of each pixel in the image
DELAY = 100 # Days parameter of Petitjean
THETA = 1.0
METHOD = "logistictimeweight"
ALPHA = 0.1 # curve slope, parameter of logistct weight
BETA = 100 # midipoint, parameter of logistct weight

# Output parameters
OUTPUTARRAY = "tmp1"




array.dim = iquery(paste("dimensions(",INPUTARRAY,")",sep=""), return=TRUE)
col_ids = paste(c(array.dim$low[1],array.dim$high[1]), collapse = ":")
row_ids = paste(c(array.dim$low[2],array.dim$high[2]), collapse = ":")

years = as.numeric(format(as.Date(FROM), "%Y")):as.numeric(format(as.Date(TO), "%Y"))
tmin = as.integer(as.Date(FROM, origin="1970-01-01") - as.Date("2000-02-18", origin="1970-01-01") )
tmax = length(which(recoverMODISDates(years, frequency=16)<TO))+1
tmax = tmax + tmax%%2

load(LIBRARYPATH)
patternnames = names(query.list)
patternnames = paste(patternnames,seq_along(patternnames),sep="_")

OUTPUTSCHEMA = paste("<",paste(paste(patternnames, collapse = ":double,"), ":double", sep=""),">",
                     " [col_id=",col_ids,",254,1,row_id=",row_ids,",254,1,year_id=2000:2020,1,1]", sep="")

if(!any(scidblist()==OUTPUTARRAY)){
  iquery(paste("CREATE ARRAY ",OUTPUTARRAY,OUTPUTSCHEMA,sep=""), afl=TRUE)
}else if( schema(scidb(OUTPUTARRAY))!=OUTPUTSCHEMA ){
  stop("The schema of array ", OUTPUTARRAY, " is diffent from the output schema.")
}

# Apply DTW using iquery/scidb
ROWS = seq(MINROW, MAXROW, SUBTILESIZEROW)
COLS = seq(MINCOL, MAXCOL, SUBTILESIZECOL)
k = 1
t1 = Sys.time()
for(i in ROWS)
  for(j in COLS){
    subtile = data.frame(xmin=j,xmax=j+SUBTILESIZECOL-1,ymin=i,ymax=i+SUBTILESIZEROW-1)
    if(subtile$xmax >= MAXCOL)
      subtile$xmax = MAXCOL
    if(subtile$ymax >= MAXROW)
      subtile$ymax = MAXROW
    strQuery = buildSciDBDTWQuery(
      INPUTARRAY = INPUTARRAY,
      OUTPUTSCHEMA = OUTPUTSCHEMA,
      PATTERNNAMES = patternnames,
      XMIN = subtile$xmin, XMAX = subtile$xmax,
      YMIN = subtile$ymin, YMAX = subtile$ymax,
      TMIN = tmin, TMAX = tmax,
      COLIDS = col_ids, ROWIDS = row_ids,
      JUNKCOL, JUNKROW,
      THRESHOLD = THRESHOLD,
      FILL = FILL,
      NORMALIZE = NORMALIZE,
      REALDAY = REALDAY,
      METHOD = METHOD,
      THETA = THETA,
      ALPHA = ALPHA,
      BETA = BETA,
      DELAY = DELAY,
      NCORES = NCORES,
      LIBRARYPATH = LIBRARYPATH,
      EXPPRPATH = EXPPRPATH
    )
    subtile_t1=Sys.time()
    iquery(paste("insert(",strQuery,",",OUTPUTARRAY,")", sep=""), return = FALSE)
    subtile_t2=Sys.time()
    cat("\nTime for DTW in SciDB:", difftime(subtile_t2,subtile_t1,tz,units="min"),"(min) Subtile:",k,"/",length(COLS)*length(ROWS),"Coordinates:",paste(subtile),"\n")
    cat("Finalized at:",as.character(subtile_t2),"\n")
    k = k + 1
  }
t2=Sys.time()
cat("\n\n\nTotal Time:", difftime(t2,t1,tz,units="hours"),"(hours) processing",scientific((MAXCOL-MINCOL)*(MAXROW-MINROW)),"time series\n")
cat("Finalized at:",as.character(t2),"\n")
