resource "aws_iam_policy" "rlt_eks_all_access_policy" {
    name = "rlt-eks-all-access-policy"
    path = "/"
    description = "Allow eksctl to create eks"
    policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "eks:*",
            "Resource": "*"
        },
        {
            "Action": [
                "ssm:GetParameter",
                "ssm:GetParameters"
            ],
            "Resource": [
                "arn:aws:ssm:*:323490220842:parameter/aws/*",
                "arn:aws:ssm:*::parameter/aws/*"
            ],
            "Effect": "Allow"
        },
        {
             "Action": [
               "kms:CreateGrant",
               "kms:DescribeKey"
             ],
             "Resource": "*",
             "Effect": "Allow"
        },
        {
             "Action": [
               "logs:PutRetentionPolicy"
             ],
             "Resource": "*",
             "Effect": "Allow"
        }        
    ]
}
)
}

resource "aws_iam_policy" "rlt_iam_limited_access_policy" {
    name = "rlt-iam-limited-access-policy"
    path = "/"
    description = "Allow eksctl to make iam"
    policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "eks:*",
            "Resource": "*"
        },
        {
            "Action": [
                "ssm:GetParameter",
                "ssm:GetParameters"
            ],
            "Resource": [
                "arn:aws:ssm:*:323490220842:parameter/aws/*",
                "arn:aws:ssm:*::parameter/aws/*"
            ],
            "Effect": "Allow"
        },
        {
             "Action": [
               "kms:CreateGrant",
               "kms:DescribeKey"
             ],
             "Resource": "*",
             "Effect": "Allow"
        },
        {
             "Action": [
               "logs:PutRetentionPolicy"
             ],
             "Resource": "*",
             "Effect": "Allow"
        },
        {
            "Action": [
                "iam:CreateRole"
            ],
            "Resource": "*",
            "Effect": "Allow"
        }
            ]
        }
)
}

data "aws_iam_policy_document" "rlt_mgmt_server_assume_role_policy" {
    statement {
      actions = ["sts:AssumeRole"]
      principals {
        type = "Service"
        identifiers = ["ec2.amazonaws.com"]
      }
    }
}

resource "aws_iam_role" "rlt_mgmt_server_role" {
    name = "rlt-mgmt-server-role"
    assume_role_policy = data.aws_iam_policy_document.rlt_mgmt_server_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "rlt_mgmt_server_role_att1" {
    role = aws_iam_role.rlt_mgmt_server_role.name
    policy_arn = aws_iam_policy.rlt_eks_all_access_policy.arn  
}

resource "aws_iam_role_policy_attachment" "rlt_mgmt_server_role_att2" {
    role = aws_iam_role.rlt_mgmt_server_role.name
    policy_arn = aws_iam_policy.rlt_iam_limited_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "rlt_mgmt_server_role_att3" {
    role = aws_iam_role.rlt_mgmt_server_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_role_policy_attachment" "rlt_mgmt_server_role_att4" {
    role = aws_iam_role.rlt_mgmt_server_role.name
    policy_arn = "arn:aws:iam::aws:policy/AWSCloudFormationFullAccess"
}
