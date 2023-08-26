# AWS App Runner with X-Ray

Two scenarios are provided:
- Public
- VPC Connector

Create the ECR and other modules:

```sh
terraform -chdir="infra" init
terraform -chdir="infra" apply
```

Now build and push the Java application to ECR:

```sh
bash app/ecrBuildPush.sh
```

Create the `.auto.tfvars` file:

```sh
touch infra/.auto.tfvars
```

Set the instance type:

```terraform
# Choose one
app_runner_workload = "PUBLIC"
app_runner_workload = "VPC"
```

Apply again to create the App Runner instance:;

```sh
terraform -chdir="infra" apply
```
