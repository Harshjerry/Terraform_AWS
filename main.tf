
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
  name = "Admin"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "*",
      "Resource": "*"
    }
  ]
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


resource "aws_s3_bucket" "finance" {
  bucket = "finance-21090test"
  tags = {
    Description ="Finance is key"
  }
}

resource "aws_s3_object" "finance-test" {
  content = "/root/finance/finance-test.doc"
  key = "finance-test.doc"
  bucket = aws_s3_bucket.finance.id
}
resource "aws_iam_group" "finance-data" {
  name= "finance-analytics"
}


resource "aws_s3_bucket_policy" "finance-policy" {
  bucket = aws_s3_bucket.finance.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Id": "ExamplePolicy01",
  "Statement": [
    {
      "Sid": "ExampleStatement01",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${aws_iam_user.test-user.arn}"
      },
      "Action": "s3:*",
      "Resource": [
        "${aws_s3_bucket.finance.arn}",
        "${aws_s3_bucket.finance.arn}/*"
      ]
    }
  ]
}
EOF
}


resource "aws_dynamodb_table" "cars" {
  name         = "cars"
  hash_key     = "VIN"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "VIN"
    type = "S"
  }
}

resource "aws_dynamodb_table_item" "car-items" {
  table_name = aws_dynamodb_table.cars.name
  hash_key   = "VIN"
  item       = <<ITEM
{
  "VIN": {"S": "1HGCM82633A004352"},
  "Make": {"S": "Honda"},
  "Model": {"S": "Accord"},
  "Year": {"N": "2003"}
}
ITEM
}
