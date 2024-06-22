resource "aws_iam_role" "vp_codepipeline_role" {
  name = "vp-codepipeline-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "codepipeline.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  role = aws_iam_role.vp_codepipeline_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ],
        Effect = "Allow",
        Resource = [
          var.codepipeline_bucket_arn,
          "${var.codepipeline_bucket_arn}/*"
        ]
      },
      {
        Action = [
          "iam:PassRole",
          "ecs:UpdateService",
          "ecs:DescribeServices",
          "ecs:DescribeTaskDefinition",
          "ecs:DescribeTasks",
          "ecs:ListTasks",
          "sts:AssumeRole"
        ],
        Effect   = "Allow",
        Resource = "*"
      },
      {
        Action = [
          "codestar-connections:UseConnection"
        ],
        Effect   = "Allow",
        Resource = var.code_start_connection_arn
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "codebuild:StartBuild",
          "codebuild:BatchGetBuilds",
          "codebuild:BatchGetProjects",
          "codebuild:BatchGetReports",
          "codebuild:ListBuildsForProject",
          "codebuild:ListCuratedEnvironmentImages",
          "codebuild:ListProjects",
          "codebuild:ListReportGroups",
          "codebuild:ListReports",
          "codebuild:ListSharedProjects",
          "codebuild:ListSharedReportGroups",
          "codebuild:StopBuild",
          "codebuild:RetryBuild"
        ],
        "Resource" : [
          var.code_build_arn
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability"
        ],
        Resource = "arn:aws:ecr:ap-southeast-1:331653881288:repository/vp-ecr-10-cicd-serverless"
      },
      {
        Effect   = "Allow",
        Action   = "ecr:GetAuthorizationToken",
        Resource = "*"
      }
    ]
  })
}
