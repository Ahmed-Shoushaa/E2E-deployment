resource "aws_default_vpc" "default-vpc" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_default_subnet" "default_az1" {
  availability_zone = "us-east-1a"

  tags = {
    Name = "Default subnet for us-east-1a"
  }
}


resource "aws_network_interface" "ni-default" {
  subnet_id = aws_default_subnet.default_az1.id
}

