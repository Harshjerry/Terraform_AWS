variable "test" {
  type = list(number)
  default = [ 0,2,3,4,5,9]
}

//terraform console can be used to test variables , list,  string ,map

variable "region" {
  default = "us-east-1"
}

variable "ami"{
  type =  map(string)
default = {
  "projA"="ami-020cba7c55df1f615"
  "projB"="ami-05ffe3c48a9991133"
}
}
  
variable "instance_type" {
  default = "t2.micro"
}
