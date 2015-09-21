#!/bin/bash
echo "##################################################"
echo "DOWNLOAD DATA"
echo "##################################################"

OUT_FOLDER=/home/scidb
BASE_URL=http://e4ftl01.cr.usgs.gov/MOLT
PRODUCT=MOD13Q1
COLLECTION=005
TILE_FILTER=h13v11
FILE_FILTER=A20[0-1][0-9][0-3][0-9][0-9]
#YEAR_START=2000
#YEAR_END=2001
RANGE_MONTHS={0..1}{0..9}
RANGE_DAYS={0..3}{0..9}
TEST=--dry-run


#parallel $TEST -j 4 --no-notice wget -r -np --retry-connrefused --wait=1 --directory-prefix $OUT_FOLDER --accept  $PRODUCT.$FILE_FILTER.$TILE_FILTER* $BASE_URL/$PRODUCT.$COLLECTION/{1}.$RANGE_MONTHS.$RANGE_DAYS/ ::: {2000..2015}
parallel -j 4 --no-notice wget -r -np --retry-connrefused --wait=1 --directory-prefix $OUT_FOLDER --accept  $PRODUCT.$FILE_FILTER.$TILE_FILTER* $BASE_URL/$PRODUCT.$COLLECTION/{1}.$RANGE_MONTHS.$RANGE_DAYS/ ::: {2000..2015}
