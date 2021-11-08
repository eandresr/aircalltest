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
            "Effect":"Allow",
            "Action": [
              "s3:GetObject",
              "s3:GetObjectVersion",
              "s3:GetBucketVersioning",
              "s3:PutObjectAcl",
              "s3:PutObject"
            ],
            "Resource": [
              "${ArtifactS3}",
              "${ArtifactS3}/*"
            ]
          },
          {
            "Effect": "Allow",
            "Action": [
              "codebuild:BatchGetBuilds",
              "codebuild:StartBuild"
            ],
            "Resource": "*"
          },
          {
            "Effect": "Allow",
            "Action": [
                "sns:Publish"
            ],
            "Resource": "${SNS}"
          },
          {
            "Effect": "Allow",
            "Action": [
                "codecommit:ListRepositoriesForApprovalRuleTemplate",
                "codecommit:GetApprovalRuleTemplate",
                "codecommit:ListApprovalRuleTemplates",
                "codecommit:ListRepositories"
            ],
            "Resource": "*"
          },
          {
            "Effect": "Allow",
            "Action": [
                "codecommit:ListPullRequests",
                "codecommit:GetPullRequestApprovalStates",
                "codecommit:ListTagsForResource",
                "codecommit:BatchDescribeMergeConflicts",
                "codecommit:GetCommentsForComparedCommit",
                "codecommit:GetCommentReactions",
                "codecommit:GetComment",
                "codecommit:GetPullRequestOverrideState",
                "codecommit:GetRepositoryTriggers",
                "codecommit:GetObjectIdentifier",
                "codecommit:BatchGetPullRequests",
                "codecommit:GetFile",
                "codecommit:GetUploadArchiveStatus",
                "codecommit:GetDifferences",
                "codecommit:GetRepository",
                "codecommit:GetMergeConflicts",
                "codecommit:GetMergeCommit",
                "codecommit:GetMergeOptions",
                "codecommit:GetTree",
                "codecommit:GetBlob",
                "codecommit:GetReferences",
                "codecommit:DescribeMergeConflicts",
                "codecommit:GetCommit",
                "codecommit:GetCommitHistory",
                "codecommit:GetCommitsFromMergeBase",
                "codecommit:BatchGetCommits",
                "codecommit:DescribePullRequestEvents",
                "codecommit:GetPullRequest",
                "codecommit:ListAssociatedApprovalRuleTemplatesForRepository",
                "codecommit:ListBranches",
                "codecommit:BatchGetRepositories",
                "codecommit:GitPull",
                "codecommit:GetCommentsForPullRequest",
                "codecommit:CancelUploadArchive",
                "codecommit:GetFolder",
                "codecommit:EvaluatePullRequestApprovalRules",
                "codecommit:GetBranch",
                "codecommit:UploadArchive"
            ],
            "Resource": "${Codecommit}"
          }
    ]
}