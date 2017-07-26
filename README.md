# etcd / terraform / digital-ocean / core-os

Adapted from https://github.com/maxenglander/etcd-terraform-example

This is for personal development to learn how these components work.

# Running

```
. ./setup_terraform
```

Prompts for and sets in the env:
* DigitalOcean API Token (to create resources)
* DigitalOcean Public Key / Private Keys so clusters can communicate

# Run Terraform
```
cd non-ssl
terraform [plan|deploy|destroy]
```

# TODO

* Get SSL version working 
* Get ETCD Proxies installed (https://coreos.com/etcd/docs/latest/v2/proxy.html)
