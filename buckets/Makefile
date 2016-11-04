push:
	gsutil rsync -m -d -r data/ gs://global-datacenter-eu/
	gsutil rsync -m -d -r data/ gs://global-datacenter-us/
	gsutil rsync -m -d -r data/ gs://global-datacenter-as/

public:
	gsutil defacl ch -u allUsers:R gs://global-datacenter-eu/
	gsutil defacl ch -u allUsers:R gs://global-datacenter-us/
	gsutil defacl ch -u allUsers:R gs://global-datacenter-as/

pull:
	gsutil rsync -r gs://global-datacenter-eu/ data/
