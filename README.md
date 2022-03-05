# waypoint-eks-express

## Local Dev

```
npm run build
npm run start
```

## Docker Dev

```
docker buildx build --platform=linux/arm64 -t eks:local .
docker run -p 3000:3000 eks:local
```

# Infra

The AWS CDK is used to spin up an EKS Cluster.

```
# from ./cdk

npx cdk deploy --outputs-file ./cdk-outputs.json
```

(Takes about 15 minutes for the cluster to be fully provisioned.)

# App

Make sure Kubectx is pointing to your new cluster

```
# this command is outputted by the CDK

aws eks update-kubeconfig --name <some_name> --region us-east-1 --role-arn arn:aws:iam::<ACCOUNT_ID>:role/some_masters_role
```

```
# from ./ (repo root)

waypoint install -platform=kubernetes -accept-tos
waypoint init
waypoint up
```
