output "db_instance_id" {
  value = "${aws_db_instance.db1.id}"
}

output "db_instance_address" {
  value = "${aws_db_instance.db1.address}"
}