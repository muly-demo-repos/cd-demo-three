module "iam_assumable_role_custom_ecr_register" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "5.48.0"

  role_name         = "custom_ecr_register"
  create_role       = true
  role_requires_mfa = false

  trusted_role_arns = [
    "arn:aws:iam::${var.aws_account_id}:user/github",
  ]
}

module "iam_policy_custom_ecr_register_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.48.0"

  name = "custom_ecr_register_role"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
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

resource "aws_iam_role_policy_attachment" "custom_ecr_register_attachment" {
  role       = module.iam_assumable_role_custom_ecr_register.iam_role_name
  policy_arn = module.iam_policy_custom_ecr_register_role.arn
}
