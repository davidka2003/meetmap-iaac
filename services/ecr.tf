resource "aws_ecr_repository" "repository" {
  for_each = { for arg in var.arguments : arg.name => arg }

  name                 = "meetmap-${each.value.name}"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository_policy" "policy" {
  for_each   = aws_ecr_repository.repository
  repository = each.value.name
  policy     = data.aws_iam_policy_document.ecr-allow-push-pull-policy.json
}
