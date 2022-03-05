import { Duration, Stack, StackProps } from 'aws-cdk-lib'
import * as eks from 'aws-cdk-lib/aws-eks'
import * as ec2 from 'aws-cdk-lib/aws-ec2'
import { Construct } from 'constructs'

export class CdkStack extends Stack {
  constructor(scope: Construct, id: string, props?: StackProps) {
    super(scope, id, props)

    // const cluster = new eks.FargateCluster(this, 'CdkFargetCluster', {
    //   version: eks.KubernetesVersion.V1_21,
    //   // vpc: vpc,
    //   endpointAccess: eks.EndpointAccess.PUBLIC,
    // })

    new eks.Cluster(this, 'CdkCluster', {
      version: eks.KubernetesVersion.V1_21,
      endpointAccess: eks.EndpointAccess.PUBLIC,
    })
    // Is this required for Waypoint server to graduate from the "Pending" state?
    // new eks.FargateProfile(this, 'MyProfile', {
    //   cluster,
    //   selectors: [{ namespace: 'default' }],
    // })
  }
}
