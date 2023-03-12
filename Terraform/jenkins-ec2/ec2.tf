resource "aws_instance" "jenkins-ec2" {
  ami           = "ami-005f9685cb30f234b" # amazon linux
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = aws_network_interface.ni-default.id
    device_index         = 0
  }
  tags = {
    Name = "jenkins-ec2"
  }
}

