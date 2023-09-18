resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    name = "dev"
  }
}

output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

resource "aws_subnet" "my_public_subnet_a" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.123.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-central-1a"

  tags = {
    name = "dev-public-a"
  }
}

resource "aws_subnet" "my_public_subnet_b" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.123.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-central-1b"

  tags = {
    name = "dev-public-b"
  }
}

resource "aws_internet_gateway" "my_gateway" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    name = "dev-gateway"
  }
}

resource "aws_route_table" "my_rt" {
  vpc_id = aws_vpc.my_vpc.id


  tags = {
    Name = "dev-public-rt"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.my_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_gateway.id
}

resource "aws_route_table_association" "my_public_assoc" {
  subnet_id      = aws_subnet.my_public_subnet_a.id
  route_table_id = aws_route_table.my_rt.id
}

resource "aws_security_group" "my-sg" {
  name   = "dev-sg"
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    description = "allow all"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "security-group-id" {
  value = aws_security_group.my-sg.id
}

resource "aws_security_group" "my-ec2-sg" {
  name   = "my-ec2-sg"
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.my-sg.id]
  }

  ingress {
    from_port   = 22
    to_port     = 22
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
    Name = "EC2 SG"
  }
}

resource "aws_key_pair" "my-keypair" {
  key_name   = "my-keypair"
  public_key = file("my-keypair.pub")
}


resource "aws_instance" "terraform-test-server" {
  instance_type = var.ec2_instance_type
  ami           = data.aws_ami.server_ami.id

  tags = {
    Name = "Terraform-test-server"
  }

  key_name               = aws_key_pair.my-keypair.id
  vpc_security_group_ids = [aws_security_group.my-ec2-sg.id]
  subnet_id              = aws_subnet.my_public_subnet_a.id

  root_block_device {
    volume_size = 10
  }

  user_data = file("userdata.tpl")
}

resource "aws_lb" "my_lb" {
  name               = "terraform-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.my-sg.id]
  subnets            = [aws_subnet.my_public_subnet_a.id, aws_subnet.my_public_subnet_b.id]

  tags = {
    environment = "codeslag-dev"
  }
}

resource "aws_lb_target_group" "my_tg" {
  name     = "my-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.my_vpc.id
}


resource "aws_lb_target_group_attachment" "attach_my_server" {
  target_group_arn = aws_lb_target_group.my_tg.arn
  target_id        = aws_instance.terraform-test-server.id
  port             = 80
}

resource "aws_lb_listener" "my-lb-listener" {
  load_balancer_arn = aws_lb.my_lb.arn
  port              = "80"
  protocol          = "HTTP"


  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_tg.arn
  }
}