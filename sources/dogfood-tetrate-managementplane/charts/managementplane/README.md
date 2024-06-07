# TSB Management Plane chart

This chart installs the TSB Management Plane operator.

It optionally allows installing along with the operator:

- the [TSB Management Plane custom resource](https://docs.tetrate.io/service-bridge/en-us/refs/install/managementplane/v1alpha1/spec)

- all the required secrets to make it run

## Install

```shell
helm install mp . --namespace tsb --create-namespace
```

## Usage

Once the TSB Management Plane operator is installed with this chart
a [TSB Management Plane custom resource](https://docs.tetrate.io/service-bridge/en-us/refs/install/managementplane/v1alpha1/spec)
is required to properly have a TSB Management Plane running.

This can be done manually or by adding the proper spec into the property `spec` of this same chart.

Check the TSB documentation for more context on how to configure the
installation: [https://docs.tetrate.io](https://docs.tetrate.io/service-bridge/en-us/setup/on_prem/management-plane-installation)

## Configuration

| Name               | Description                                            | Default value                        |
|--------------------|--------------------------------------------------------|--------------------------------------|
| `image.registry`   | Registry used to download the operator image. Required | `gcr.io/tetrate-internal-containers` |
| `image.tag`        | The tag of the operator image. Required                | `TODO replace`                       |
| `image.pullPolicy` | The policy to pull the operator image. Required        | `IfNotPresent`                       |

## Management Plane resource configuration

Optionally
the [TSB Management Plane custom resource](https://docs.tetrate.io/service-bridge/en-us/refs/install/managementplane/v1alpha1/spec)
can be supplied using the following configuration to make the TSB Management Plane fully run.

| Name             | Description                                                                | Default value                        |
|------------------|----------------------------------------------------------------------------|--------------------------------------|
| `spec`           | Holds the `spec` section of the Management Plane custom resource. Optional ||

## Secrets configuration

Also, optionally, all the required secrets can be supplied using the following configuration.

NOTE: Keep in mind that these options just help with creating secrets, and they must respect the configuration provided
in the TSB Management Plane custom resource, otherwise the installation will end up misconfigured.

| Name                              | Description                                                                                                                                                                                                                                         | Default value |
|-----------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------|
| `secrets.keep`                    | Enabling this makes the generated secrets persist in the cluster after uninstalling the chart if they are no provided in future updates. (see [Helm doc](https://helm.sh/docs/howto/charts_tips_and_tricks/#tell-helm-not-to-uninstall-a-resource)) | `false`       |                                                                                                                                                
| `secrets.tsb.adminPassword`       | The password that is going to be configured for the `admin` user.                                                                                                                                                                                   ||
| `secrets.tsb.cert`                | The TLS certificate exposed by the Management Plane (front envoy).                                                                                                                                                                                  ||
| `secrets.tsb.key`                 | The key for TLS certificate exposed by the Management Plane (front envoy).                                                                                                                                                                          ||
| `secrets.postgres.username`       | The username used to access the Postgres database.                                                                                                                                                                                                  ||
| `secrets.postgres.password`       | The password used to access the Postgres database.                                                                                                                                                                                                  ||
| `secrets.postgres.cacert`         | The CA cert to verify TLS certificates provided by the Postgres database.                                                                                                                                                                           ||
| `secrets.postgres.clientcert`     | The client cert required to access the Postgres database.                                                                                                                                                                                           ||
| `secrets.postgres.clientkey`      | The key for the client cert required to access the Postgres database.                                                                                                                                                                               ||
| `secrets.elasticsearch.username`  | The username used to access the Elasticsearch.                                                                                                                                                                                                      ||
| `secrets.elasticsearch.password`  | The password used to access the Elasticsearch.                                                                                                                                                                                                      ||
| `secrets.elasticsearch.cacert`    | The CA cert to verify TLS certificates provided by the Elasticsearch.                                                                                                                                                                               ||
| `secrets.ldap.binddn`             | The bind DN used to read from the LDAP IDP.                                                                                                                                                                                                         ||
| `secrets.ldap.bindpassword`       | The password for the provided bind DN used to read from the LDAP IDP.                                                                                                                                                                               ||
| `secrets.ldap.cacert`             | The CA cert to verify TLS certificates provided by the LDAP IDP.                                                                                                                                                                                    ||
| `secrets.oidc.clientSecret`       | The client secret used to connect to the configured OIDC.                                                                                                                                                                                           ||
| `secrets.oidc.deviceClientSecret` | The device client secret used to connect to the configured OIDC.                                                                                                                                                                                    ||
| `secrets.azure.clientSecret`      | The client secrect used to connect to the Azure OIDC.                                                                                                                                                                                               ||

### XCP secrets configuration

XCP uses TLS and JWTs to authenticate between Edges and Central.

If `secrets.xcp.autoGenerateCerts` is **disabled**, the certificate for XCP Central and the key must be provided by the
user using `secrets.xcp.central.cert` and `secrets.xcp.central.key`.

Optionally, a CA can be provided with `secrets.xcp.rootca` to allow the MPC component to use it to verify the certs
provided by XCP Central.

If `secrets.xcp.autoGenerateCerts` is **enabled**, Cert Manager is required to provide the XCP Central certificate.

Then `secrets.xcp.rootca` and `secrets.xcp.rootcakey` will be used to create the proper Issuer and generate the
certificate for XCP Central and share the CA with MPC to allow it to verify the XCP Central generated cert.

The following properties are allowed to be used to configure the XCP authentication mode:

| Name                                        | Description                                                                                                        | Default value            |
|---------------------------------------------|--------------------------------------------------------------------------------------------------------------------|--------------------------|
| `secrets.xcp.autoGenerateCerts`             | Enabling this will auto generate the XCP Central TLS certificate. Requires cert-manager                            | `false`                  |
| `secrets.xcp.rootca`                        | The XCP components CA certificate.                                                                                 ||
| `secrets.xcp.rootcakey`                     | The XCP components Root CA certificate key.                                                                        ||
| `secrets.xcp.central.cert`                  | The XCP Central certificate for TLS.                                                                               ||
| `secrets.xcp.central.key`                   | The XCP Central certificate key for TLS.                                                                           ||
| `secrets.xcp.central.additionalDNSNames`    | Additional DNS names to be added in the XCP Central certificate when `secrets.xcp.autoGenerateCerts` is enabled    ||
| `secrets.xcp.central.additionalURIs`        | Additional URIs to be added in the XCP Central certificate when `secrets.xcp.autoGenerateCerts` is enabled         ||
| `secrets.xcp.central.additionalIPAddresses` | Additional IP addresses to be added in the XCP Central certificate when `secrets.xcp.autoGenerateCerts` is enabled ||
| `certManager.clusterResourcesNamespace`     | The namespace configured in the Cert Manager installation for cluster resources.                                   | `cert-manager`           |

## Operator extended configuration

The TSB operator related resources like the deployment, the service or the service account can be extended using the
following optional properties:

| Name                                       | Description                                                                      | Default value |
|--------------------------------------------|----------------------------------------------------------------------------------|---------------|
| `operator.deployment.affinity`             | Affinity configuration for the pod                                               ||
| `operator.deployment.annotations`          | Custom collection of annotations to add to the deployment                        ||
| `operator.deployment.env`                  | Custom collection of env vars to add to the container                            ||
| `operator.deployment.podAnnotations`       | Custom collection of annotations to add to the pod                               ||
| `operator.deployment.replicaCount`         | Number of replicas managed by the deployment                                     ||
| `operator.deployment.strategy`             | Deployment strategy to use                                                       ||
| `operator.deployment.tolerations`          | Toleration collection applying to the pod scheduling                             ||
| `operator.service.annotations`             | Custom collection of annotations to add to the service                           ||
| `operator.serviceAccount.annotations`      | Custom collection of annotations to add to the service account                   ||
| `operator.serviceAccount.imagePullSecrets` | Collection of secrets names required to be able to pull images from the registry ||
| `operator.pullSecret`                      | A Docker JSON config string that will be stored as an image pull secret          ||
