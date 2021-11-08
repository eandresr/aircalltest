{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "iam:*"
            ],
            "Resource": "*",
            "Effect": "Deny",
            "Sid": "DenyActionsIAMGlobal"
        },
        {
            "Effect": "Allow",
            "Action": "logs:CreateLogGroup",
            "Resource": "arn:aws:logs:${Region-Id}:${Account-Id}:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:logs:${Region-Id}:${Account-Id}:log-group:/aws/lambda/${CodeBuild-Name}:*"
            ]
        },
        {
            "Sid": "codebuild",
            "Effect": "Allow",
            "Action": [
                "codecommit:GitPull",
                "ecr:BatchCheckLayerAvailability",
                "ecr:CompleteLayerUpload",
                "ecr:GetAuthorizationToken",
                "ecr:InitiateLayerUpload",
                "ecr:PutImage",
                "ecr:UploadLayerPart",
                "ecs:RunTask",
                "iam:PassRole",
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "ssm:GetParameters",
                "secretsmanager:GetSecretValue"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "codebuildartifacts",
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": [
                "${ArtifactS3}",
                "${ArtifactS3}/*"
            ]
        },
        {
            "Sid": "lambdaupdate",
            "Effect": "Allow",
            "Action": [
                "lambda:GetFunctionConfiguration",
                "lambda:ListProvisionedConcurrencyConfigs",
                "lambda:GetProvisionedConcurrencyConfig",
                "lambda:ListTags",
                "lambda:GetAlias",
                "lambda:GetFunction",
                "lambda:ListAliases",
                "lambda:UpdateFunctionCode",
                "lambda:ListFunctionEventInvokeConfigs",
                "lambda:GetFunctionConcurrency",
                "lambda:GetFunctionEventInvokeConfig",
                "lambda:PublishVersion",
                "lambda:GetPolicy"
            ],
            "Resource": [
                "${Function}",
                "${Function}/*"
            ]
        },
        {
            "Sid": "lambdaget",
            "Effect": "Allow",
            "Action": [
                "lambda:ListFunctions",
                "lambda:ListEventSourceMappings",
                "lambda:GetAccountSettings",
                "lambda:ListLayers",
                "lambda:ListLayerVersions",
                "s3:ListMultiRegionAccessPoints",
                "lambda:ListCodeSigningConfigs"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}