variable "AWS_ACCESS_KEY" { type = string default = "XXX" } variable "AWS_SECRET_KEY" { type = string default = "XXX" }

variable "AWS_REGION" {
    default = "us-east-2"
}

variable "AMIS" {
    type=map
    default= {
          us-east-1 = "ami-0690a02353dabd3bc"
          us-east-2 = "ami-09fbe37c5a19bfd7c"
          us-west-1 = "ami-0f97b8036e6aa29b1"
          us-west-2 = "ami-01b0cd189e4ffaa4d"
          eu-north-1 = "ami-000e50175c5f86214"
    }
}

variable "PATH_TO_PRIVATE_KEY" {
    default="net-key-elb"
}

variable "PATH_TO_PUBLIC_KEY" {
    default= "net-key-elb.pub"
}

variable "INSTANCE_USERNAME" {
    default= "ubuntu"
}

variable "REGIONS" {
  type    = list(string)
  default = ["us-east-2a", "us-east-2b", "us-east-2c"]
}
