resource "aws_iam_group" "developer" {
  name = "developer-group"

}

resource "aws_iam_group_policy_attachment" "developer-ecr" {
  group      = aws_iam_group.developer.name
  policy_arn = aws_iam_policy.allow-pull-push-ecr.arn
}

resource "aws_iam_group_policy_attachment" "developer-ecs" {
  group      = aws_iam_group.developer.name
  policy_arn = aws_iam_policy.allow-update-ecs-deployment.arn
}

resource "aws_iam_group_policy_attachment" "developer-opensearch" {
  group      = aws_iam_group.developer.name
  policy_arn = aws_iam_policy.allow-update-ecs-deployment.arn
}

resource "aws_iam_policy" "allow-pull-push-ecr" {
  name        = "pull-push-ecr"
  description = "Allow pull and push to ecr for developers"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "ecr:CompleteLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:InitiateLayerUpload",
                "ecr:BatchCheckLayerAvailability",
                "ecr:PutImage",
                "ecr:GetAuthorizationToken"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}


resource "aws_iam_policy" "allow-update-ecs-deployment" {
  name        = "update-ecs-deployment"
  description = "Allow create new deployments for ecs services"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "ecs:UpdateService"
            ],
            "Resource": "*"
        }
    ]
}
  EOF
}
//@todo fix it later, restrict access !!important
# resource "aws_iam_policy" "allow-full-access-opensearch" {
#   name        = "allow-full-access-opensearch"
#   description = "Allow full access to all opensearches"
#   policy      = <<EOF
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Sid": "VisualEditor0",
#             "Effect": "Allow",

#             "Resource": "*"
#         }
#     ]
# }
#   EOF
# }

