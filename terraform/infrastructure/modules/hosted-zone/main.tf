resource "aws_iam_role" "ses_sending_role" {
  name               = "ses-sending-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ses.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "ses_sending_policy" {
  name = "ses-sending-policy"
  role = aws_iam_role.ses_sending_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ses:SendEmail",
        "ses:SendRawEmail"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_route53_zone" "rz" {
  name = var.domain_url
}

resource "aws_ses_domain_identity" "ses_di" {
  domain = var.domain_url
}

resource "aws_route53_record" "ses_verification_record" {
  zone_id = aws_route53_zone.rz.id
  name    = aws_ses_domain_identity.ses_di.domain
  type    = "TXT"
  ttl     = 60
  records = [aws_ses_domain_identity.ses_di.verification_token]
}

resource "aws_ses_domain_dkim" "ses_ddkim" {
  domain = aws_ses_domain_identity.ses_di.domain
}

resource "aws_route53_record" "ses_dkim_record" {
  count   = 3
  zone_id = aws_route53_zone.rz.id
  name    = element(aws_ses_domain_dkim.ses_ddkim.dkim_tokens, count.index)
  type    = "CNAME"
  ttl     = 60
  records = [element(aws_ses_domain_dkim.ses_ddkim.dkim_tokens, count.index)]
}

resource "aws_ses_email_identity" "example" {
  email = var.admin_email
}
