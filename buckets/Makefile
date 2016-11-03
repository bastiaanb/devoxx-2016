push:
	gsutil rsync -d -r data/ gs://global-datacenter-eu/ 
	gsutil rsync -d -r data/ gs://global-datacenter-us/ 
	gsutil rsync -d -r data/ gs://global-datacenter-as/ 

pull:
	gsutil rsync -r gs://global-datacenter-eu/ data/
