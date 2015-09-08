twdtwSugarCaneSP
============

Scripts to reproduce the results presented in "Sugar cane identification in São Paulo state using Time-Weighted Dynamic Time Warping".

<h3>Files:</h3>
<ul>
  <li><code>LICENSE</code> - License file.</li>
  <li><code>README.md</code> - This file.</li>


  <li>Docker files:
    <ul>
      <li><code>Dockerfile</code> - Docker file for building a Docker Image.</li>
      <li><code>setup.sh</code> - Host script. It launches a Docker container.
    </ul>
  </li>

  <li>Container files:
		<ul>
			<li><code>containerSetup.sh</code> - Script for setting up SciDB in a docker container.</li>
			<li><code>iquery.conf</code> - IQUERY configuration file.</li>
			<li><code>startScidb.sh</code> - Container script for starting SciDB.</li>
			<li><code>stopScidb.sh</code> - Container script for stopping SciDB.</li>
			<li><code>scidb_docker.ini</code> - SciDB's configuration file.</li>
      <li><code>conf</code> - SHIM configuration file.</li>
      <li><code>createArray.afl</code> - AFL query to build the destination array.</li>

      <li><code>installBoost_1570.sh</code> - Script for installing Boost libraries.</li>
      <li><code>installGdal_1112.sh</code> - Script for installing gdal.</li>
      <li><code>installGribModis2SciDB.sh</code> - Script for installing gdal.</li>

		</ul>
	</li>

</ul>




git clone https://github.com/albhasan/twdtwSugarCaneSP.git
cd twdtwSugarCaneSP/
./setup.sh
ssh -p
OPTIONAL docker ps
ssh -p 48901 root@localhost
OPTIONAL answer yes to add the container to the list of known hosts
