#!/bin/bash
#echo "##################################################"
#echo "SET SCIDB ENVIRONMENTAL VARIABLES TO bashrc"
#echo "##################################################"
echo "#***** ***** SCIDB" >> ~/.bashrc
echo "SCIDB_VER=14.12" >> ~/.bashrc
echo "PATH=$PATH:/opt/scidb/$SCIDB_VER/bin:/opt/scidb/$SCIDB_VER/share/scidb" >> ~/.bashrc
echo "LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/scidb/$SCIDB_VER/lib" >> ~/.bashrc

