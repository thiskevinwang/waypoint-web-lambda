#!/usr/bin/env node
import 'dotenv/config'

import * as cdk from 'aws-cdk-lib'
import { CdkStack } from '../lib/cdk-stack'

const app = new cdk.App()
new CdkStack(app, 'CdkStack', {
  env: {
    account: process.env.AWS_ACCOUNT_ID,
    region: process.env.AWS_REGION,
  },
})
