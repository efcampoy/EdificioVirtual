# crear instancia


resource "aws_security_group" "building_security_group" {
  vpc_id = aws_vpc.building_vpc.id

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol   = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "building_permitir_http_ssh"
  }

}


resource "aws_instance" "building_web" {
  ami           = "ami-005fc0f236362e99f"
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = aws_network_interface.building_instance_interface.id
    device_index         = 0
  }



  user_data = <<-EOF
                #!/bin/bash   
                printf "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDMOxw27viuNyaie/M4ma9i0p3K4lUyhq13hsQjELKrgQD/V7RRFGTTFsABeJxHAfElWGlx0FuifjJQ0QPJ75+bc/ry8YGdY+qUhuca6eAkxqeAWwOQTDg8lVt9kHt8Dveu1rt1I3T+LFYFb6GXvhB8Bt48YrYUDcU6Sx0jTrfNihxNOsQSg3CSkAcUtlkn8VoqAuNASQl2RfrtbZdELiZD0ZmcKZLcIgq9FTe9FmSfwDfqsi6mGZAqtvpS2dXJgis6FzWEqsrZZtQa5AK3wtdCP8NYo9dPk305/LCrD+NDfIDw7zUaOLDv60tLiGH6St8hOV7uUklYJr75QYd0A1IP fdzc@MSI" > /home/ubuntu/.ssh/authorized_keys
                sudo apt update
                sudo apt install nginx -y
                sudo systemctl enable nginx
                sudo mkdir -p /var/www/html
                EOF


  tags = {
    Name = "buildindg_web"
  }
}

resource "aws_network_interface" "building_instance_interface" {
  subnet_id       = aws_subnet.public_building_subnet.id
  private_ips     = ["10.0.100.50"]
  security_groups = [aws_security_group.building_security_group.id]

}

resource "aws_key_pair" "building-ssh-key" {
  key_name   = "building-ssh-key"
  public_key = file("building_web.key.pub")
}




