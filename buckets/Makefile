push:
	gsutil -m rsync -d -r data/ gs://global-datacenter-eu/
	gsutil -m rsync -d -r data/ gs://global-datacenter-us/
	gsutil -m rsync -d -r data/ gs://global-datacenter-as/

public:
	gsutil defacl ch -u allUsers:R gs://global-datacenter-eu/
	gsutil defacl ch -u allUsers:R gs://global-datacenter-us/
	gsutil defacl ch -u allUsers:R gs://global-datacenter-as/

pull:
	gsutil -m rsync -r gs://global-datacenter-eu/ data/
