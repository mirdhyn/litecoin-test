resource "aws_iam_role" "role" {
  name = "${var.name}-${var.role_suffix}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })

  tags = {
    env = "${var.name}"
  }
}

resource "aws_iam_policy" "policy" {
  name = "${var.name}-${var.policy_suffix}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
        ]
        Effect   = "Allow"
        "Principal": { "AWS": "arn:aws:iam::${var.account_id}:role/${var.name}-${var.role_suffix}" }
      },
    ]
  })
}

resource "aws_iam_group" "group" {
  name = "${var.name}-${var.group_suffix}"
}

resource "aws_iam_group_policy_attachment" "attach-policy-to-group" {
  group       = aws_iam_group.group.name
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_user" "user" {
  name = "${var.name}-${var.user_suffix}"

  tags = {
    env = "var.name"
  }
}

resource "aws_iam_user_group_membership" "attach-user-to-group" {
  user = aws_iam_user.user.name

  groups = [
    aws_iam_group.group.name,
  ]
}
