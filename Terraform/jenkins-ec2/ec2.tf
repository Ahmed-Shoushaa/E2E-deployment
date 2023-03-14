locals {
  key_name        = "jenkins-ansible"
  private_key_path = "jenkins-ec2/jenkins-ansible.pem"
}

resource "aws_instance" "jenkins-ec2" {
  ami           = "ami-005f9685cb30f234b" # amazon linux
  instance_type = "t2.small"
  key_name      = local.key_name
  network_interface {
    network_interface_id = aws_network_interface.ni-default.id
    device_index         = 0
  }
  provisioner "remote-exec" {
    inline = ["echo 'wait untill SSH is ready'"]
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(local.private_key_path)
      host        = aws_instance.jenkins-ec2.public_ip
    }

  }
  provisioner "local-exec" {
    command = "ansible-playbook -i ${aws_instance.jenkins-ec2.public_ip}, --private-key ${local.private_key_path} jenkins-ec2/playbook.yaml"
    #command = "ansible-playbook -i ${aws_instance.jenkins-ec2.public_ip}, --private-key ${local.private_key_path} playbook.yaml"
  }

  tags = {
    Name = "jenkins-ec2"
  }
}

output "instance-ip" {
  value       = aws_instance.jenkins-ec2.public_ip
}


