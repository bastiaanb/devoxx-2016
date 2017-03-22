NOMAD_VERSION=0.5.5
CONSUL_VERSION=0.7.5
HASHICORP_BASEURL=https://releases.hashicorp.com
FABIO_VERSION=1.3.8-go1.8
HASHI_UI_VERSION=v0.13.4

NOMAD_ZIP:=data/hashicorp/nomad/$(NOMAD_VERSION)/nomad_$(NOMAD_VERSION)_linux_amd64.zip
CONSUL_ZIP:=data/hashicorp/consul/$(CONSUL_VERSION)/consul_$(CONSUL_VERSION)_linux_amd64.zip
FABIO:=data/fabio/fabio-$(FABIO_VERSION)-linux_amd64
HASHI_UI:=data/hashi-ui/$(HASHI_UI_VERSION)/hashi-ui-linux-amd64

$(NOMAD_ZIP):
	install -d $(shell dirname $@)
	wget -q -O $@ $(HASHICORP_BASEURL)/nomad/$(NOMAD_VERSION)/nomad_$(NOMAD_VERSION)_linux_amd64.zip

$(CONSUL_ZIP):
	install -d $(shell dirname $@)
	wget -q -O $@ $(HASHICORP_BASEURL)/consul/$(CONSUL_VERSION)/consul_$(CONSUL_VERSION)_linux_amd64.zip

$(FABIO):
	install -d $(shell dirname $@)
	wget -q -O $@ https://github.com/eBay/fabio/releases/download/v$(shell cut -d- -f1 <<< $(FABIO_VERSION))/fabio-$(FABIO_VERSION)-linux_amd64

$(HASHI_UI):
	install -d $(shell dirname $@)
	wget -q -O $@ https://github.com/jippi/hashi-ui/releases/download/$(HASHI_UI_VERSION)/hashi-ui-linux-amd64

download: $(NOMAD_ZIP) $(CONSUL_ZIP) $(FABIO) $(HASHI_UI)

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
