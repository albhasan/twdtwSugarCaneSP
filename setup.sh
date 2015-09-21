#!/bin/bash
docker stop scidb_twdtwscsp1
docker rm scidb_twdtwscsp1
docker rmi scidb_twdtwscsp_img
docker build --rm=true --tag="scidb_twdtwscsp_img" .


# CHRONOS
#rm -rf /dados1/scidb/dockerCdata/scidb_twdtwscsp1/data/*
#docker run -d --dns=150.163.2.4 --dns-search=dpi.inpe.br --name="scidb_twdtwscsp1" -p 48901:22 -p 48902:8083 --expose=5432 --expose=1239 -v /net/chronos/dados1/modisOriginal:/home/scidb/modis -v /dados1/scidb/dockerCdata/scidb_twdtwscsp1/data:/home/scidb/data scidb_twdtwscsp_img




docker run -d --name="scidb_twdtwscsp1" -p 48901:22 -p 48902:8083 --expose=5432 --expose=1239 scidb_twdtwscsp_img
