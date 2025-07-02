
# provider "aws" {
#     region = "us-east-1"
#     access_key = ""
#     secret_key = ""
# }
//only use provider when you cli is not configured  , not a best seurity principle

resource "aws_iam_user" "test-user" {
 name= "harsh"
 tags= {
    Description ="Tech Team Leader"
 } 
}

resource "aws_iam_policy" "admin" {
name="Admin"
policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Action": "*",
    "Resource": "*"
  }
}
 EOF
}

//way 2 to add   iam policy form json file
# resource "aws_iam_policy" "admin" {
# name="Admin"
# policy = file("test-policy.json")
# }

resource "aws_iam_user_policy_attachment" "harsh-admin-access" {
    user= aws_iam_user.test-user.name
    policy_arn = aws_iam_policy.admin.arn
}