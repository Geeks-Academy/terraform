resource "aws_iam_role" "allow_posting_to_sns" {
  name = "allow_posting_to_sns"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [ {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "autoscaling.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
  } ]
}
EOF
}

data "aws_iam_policy_document" "allow_posting_to_sns" {

  statement {
    sid    = "AllowWritingLogs"
    effect = "Allow"

    resources = [
      "arn:aws:sns:*:*:asg_events"
    ]

    actions = [
      "sns:Publish"
    ]
  }
}

resource "aws_iam_policy" "allow_posting_to_sns" {
  name   = "allow_posting_to_sns"
  policy = data.aws_iam_policy_document.allow_posting_to_sns.json
}

resource "aws_iam_role_policy_attachment" "allow_posting_to_sns" {
  policy_arn = aws_iam_policy.allow_posting_to_sns.arn
  role       = aws_iam_role.allow_posting_to_sns.name
}
