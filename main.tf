provider "aws" {
  region = var.region
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-north-1a"
  map_public_ip_on_launch = true
}

resource "aws_security_group" "web" {
  name        = "web_sg"             # <-- Added 'name' attribute
  description = "Allow SSH and HTTP" # <-- Added 'description' attribute
  vpc_id      = aws_vpc.main.id

  # Corrected: Each ingress rule is a nested block
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Corrected: Egress is a nested block
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # '-1' means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami           = "ami-0c7d68785ec07306c"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web.id]
  key_name      = var.key_name
  tags = { Name = "TerraformWeb" }
}

#output "instance_public_ip" {
#  value = aws_instance.web.public_ip
#}

