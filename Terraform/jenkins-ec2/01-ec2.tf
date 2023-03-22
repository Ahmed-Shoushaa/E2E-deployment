locals {
  key_name         = "ohio"
  private_key_path = "jenkins-ec2/ohio.pem"
}
resource "aws_instance" "jenkins-ec2" {
  ami                         = "ami-02238ac43d6385ab3"
  instance_type               = "t2.medium"
  vpc_security_group_ids      = [aws_security_group.jenkins_sg.id]
  associate_public_ip_address = true
  key_name                    = "ohio" # your key here
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
  }

  user_data = <<EOF
                  #!/bin/bash
                  # install git
                  sudo yum install git -y

                  # install kubectl
                  sudo curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.23.6/bin/linux/amd64/kubectl
                  sudo chmod +x ./kubectl
                  sudo mkdir -p $HOME/bin && sudo cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin

                  #install docker 
                  sudo yum install docker -y
                  sudo groupadd docker
                  sudo systemctl start docker
                  sudo chmod 666 /var/run/docker.sock
                  sudo usermod -a -G docker ec2-user
                  sudo usermod -aG docker jenkins
                  sudo yum install python3-pip -y
                  sudo pip3 install docker-compose
                  EOF

  tags = {
    Name = "Jenkins-EC2"
  }

}

output "jenkins-server-ip" {
  value = aws_instance.jenkins-ec2.public_ip
}