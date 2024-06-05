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
