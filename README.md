# AWS App Runner with X-Ray

Two scenarios are provided:

- Public
- Public with VPC Connector

Create the ECR and other modules:

```sh
terraform -chdir="infra" init
terraform -chdir="infra" apply -auto-approve
```

Now, build and push the Java application to ECR:

```sh
(cd ./app; bash ./ecrBuildPush.sh)
```

Create the `.auto.tfvars` file:

```sh
touch infra/.auto.tfvars
```

Set the instance type:

```terraform
# Choose one
app_runner_workload = "PUBLIC"
app_runner_workload = "PUBLIC_WITH_VPC"
```

Apply again to create the App Runner instance:

```sh
terraform -chdir="infra" apply -auto-approve
```

## Actuator


```sh
curl https://<service-id>.us-east-2.awsapprunner.com/actuator/health
```

---

### Clean-up

Destroy the resources when done:

```sh
terraform -chdir="infra" destroy -auto-approve
```
