# waypoint-eks

## Structure

```
├── cdk
├── go
│   └── gin
└── nodejs
    └── express
```

### `cdk`

Infrastructure as code via the AWS TypeScript CDK.

This code provisions an EKS Cluster, and outputs a command to add the cluster to your local `kubectx`.
This enables the `waypoint` CLI to connect to your cluster.

```
# from ./cdk

npx cdk deploy --outputs-file ./cdk-outputs.json
```

(Takes about 15 minutes for the cluster to be fully provisioned.)

```
# this command is outputted by the CDK

aws eks update-kubeconfig --name <some_name> --region us-east-1 --role-arn arn:aws:iam::<ACCOUNT_ID>:role/some_masters_role
```

## Apps

Deploy either of the webserver apps with:

```
# from ./go/gin or ./nodejs/express

waypoint install -platform=kubernetes -accept-tos
waypoint init
waypoint up
```
