variable "tag_name"           {}
variable "identifier"         {}
variable "storage"            {}
variable "engine"             {}
variable "engine_version"     {}
variable "instance_class"     {}
variable "db_name"            {}
variable "username"           {}
variable "password"           {}
variable "port"               {}
variable "vpc_id"             {}
variable "public_subnet_ids"  { default = [] }

resource "aws_db_instance" "db1" {
  depends_on             = ["aws_security_group.db_security_group"]
  identifier             = "${var.identifier}"
  allocated_storage      = "${var.storage}"
  engine                 = "${var.engine}"
  engine_version         = "${var.engine_version}"
  instance_class         = "${var.instance_class}"
  name                   = "${var.db_name}"
  username               = "${var.username}"
  password               = "${var.password}"
  multi_az               = false
  storage_type           = "gp2"
  port                   = "${var.port}"
  backup_retention_period= 1
  vpc_security_group_ids = ["${aws_security_group.db_security_group.id}"]
  db_subnet_group_name   = "${aws_db_subnet_group.db_subnet_group.id}"
  tags {
    Name = "${var.tag_name}-db1"
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name        = "main_subnet_group"
  description = "Our main group of subnets"
  subnet_ids  = ["${var.public_subnet_ids}"]
}

resource "aws_security_group" "db_security_group" {
  name        = "${var.tag_name}-db-sg"
  description = "Allow MySQL inbound traffic"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = "${var.port}"
    to_port     = "${var.port}"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.tag_name}-db-sg"
  }
}