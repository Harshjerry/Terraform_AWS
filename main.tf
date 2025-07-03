
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


 resource "aws_instance" "webserver" {
 ami= "ami-020cba7c55df1f615"
 instance_type = "t2.micro"
 key_name      = aws_key_pair.webserver_key.key_name
 tags = {
 Name= "webserver"
 Description = "An Nginx WebServer on Ubuntu"
 }

  user_data = <<-EOF
 #!/bin/bash
 sudo apt update
 sudo apt install nginx-y
 systemctl enable nginx
 systemctl start nginx
 EOF
 vpc_security_group_ids = [aws_security_group.ssh-access.id]
 }


 resource "aws_security_group" "ssh-access" {
  name        = "ssh-access"
  description = "Allow SSH access from the Internet"
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "publicIP" {
  value = aws_instance.webserver.public_ip
}
# Create a key pair
resource "aws_key_pair" "webserver_key" {
  key_name   = "webserver-key"
  public_key = file("~/.ssh/id_rsa.pub")  # Path to your public key
}
