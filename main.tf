module "network" {
  source           = "./modules/network"
  project_name     = tp-modules
  vpc_name         = vpc-tp-modules
  env              = dev
}

# Security Groups
resource "aws_security_group" "bastion1" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allow_ssh_from
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-${var.env}-sg-bastion1"
  }
}

resource "aws_security_group" "application1" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion1.id]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-${var.env}-sg-application1"
  }
}

resource "aws_security_group" "load_balancer1" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-${var.env}-sg-load-balancer1"
  }
}

# Key-pairs
resource "tls_private_key" "admin_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}



# Instances
resource "aws_instance" "bastion1" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public1.id
  vpc_security_group_ids = [aws_security_group.bastion1.id]
  key_name               = var.key_name

#  provisioner "file" {
#    content     = tls_private_key.admin_key.private_key_pem
#    destination = "/home/ec2-user/.ssh/id_rsa"
#  }
#
#  provisioner "remote-exec" {
#    inline = [
#      "chmod 400 /home/ec2-user/.ssh/id_rsa",
#      "echo 'Key added to bastion.'"
#    ]
#  }
#
#  connection {
#    type        = "ssh"
#    user        = "ec2-user"
#    private_key = tls_private_key.admin_key.private_key_pem
#    host        = self.public_ip
#  }

  associate_public_ip_address = true

  tags = {
    Name        = "${var.project_name}-bastion1"
    Environment = "production"
  }
}

resource "aws_instance" "application1" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private1.id
  vpc_security_group_ids = [aws_security_group.application1.id]

#  provisioner "remote-exec" {
#    inline = [
#      "sudo yum update -y",
#      "sudo amazon-linux-extras enable nginx1",
#      "sudo yum install nginx -y",
#      "sudo systemctl start nginx",
#      "sudo systemctl enable nginx",
#      "sudo bash -c 'echo \"<h1>Welcome to Terraform Nginx Server</h1>\" > /usr/share/nginx/html/index.html'",
#    ]
#  }
#
#  provisioner "file" {
#    content     = tls_private_key.admin_key.public_key_openssh # Chemin vers la clé publique
#    destination = "/home/ec2-user/.ssh/authorized_keys"
#  }
#
#  connection {
#    type        = "ssh"
#    user        = "ec2-user"
#    private_key = tls_private_key.admin_key.private_key_pem
#    host        = self.private_ip
#    bastion_host = aws_instance.bastion1.public_ip
#    bastion_user = "ec2-user"
#    bastion_private_key = tls_private_key.admin_key.private_key_pem
#  }

  associate_public_ip_address = false

  tags = {
    Name        = "${var.project_name}-application1"
    Environment = "production"
  }
}

# Load balancer
resource "aws_lb" "main1" {
  name               = "${var.project_name}-lb1"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.load_balancer1.id]
  subnets            = [aws_subnet.public1.id, aws_subnet.public2.id]

  tags = {
    Name        = "${var.project_name}-load-balancer1"
    Environment = "production"
  }
}

resource "aws_lb_target_group" "application1" {
  name     = "${var.project_name}-tg1"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name        = "${var.project_name}-target-group1"
    Environment = "production"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main1.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.application1.arn
  }
}

resource "aws_lb_target_group_attachment" "application1" {
  target_group_arn = aws_lb_target_group.application1.arn
  target_id        = aws_instance.application1.id
  port             = 80
}
