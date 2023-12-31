resource "aws_security_group" "main" {
  name        = "${var.name}-${var.env}-sg"
  description = "${var.name}-${var.env}-sg"
  vpc_id      = var.vpc_id

  ingress {
    description = "RABBITMQ"
    from_port   = var.port_number
    to_port     = var.port_number
    protocol    = "tcp"
    cidr_blocks = var.allow_db_cidr
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.bastion_cidr
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(var.tags, { Name = "${var.name}-${var.env}-sg" })
}

resource "aws_instance" "rabbitmq" {
  ami                    = data.aws_ami.centos.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.main.id]
  tags                   = merge(var.tags, { Name = "${var.name}-${var.env}" })

  user_data = base64encode(templatefile("${path.module}/userdata.sh", {
    rabbitmq_appuser_password = data.aws_ssm_parameter.rabbitmq_appuser_password.value
  }))

}