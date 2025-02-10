# dogfood-helm charts repository

## Adding the Helm Repository

To use the charts from the DogFood repository:

```bash
helm repo add dogfood-helm https://tetratecx.github.io/dogfood-helm
helm repo update
helm search repo dogfood-helm
```

## Helm charts releases

Any updates to `source` directory will trigger github actions workflow to update/release helm charts.

## Examples

Example usage for obs-svc:
```bash
helm search repo dogfood-helm

helm install frontend dogfood-helm/obs-svc -n obstest --set svcName=frontend --set svcVersion=v1

helm install svca dogfood-helm/obs-svc -n obstest --set svcName=svca --set svcVersion=v1

helm install svcb dogfood-helm/obs-svc -n obstest --set svcName=svcb --set svcVersion=v1

helm install postgres dogfood-helm/obs-svc -n obstest --set svcName=postgres --set svcVersion=v1

helm install internal-client dogfood-helm/fortio-svc -n obstest --set svcName=internal-client --set svcVersion=v1 \
  --set targetURL=http://frontend.obstest/proxy/[svca/proxy/postgres][svcb/proxy/postgres]
```
