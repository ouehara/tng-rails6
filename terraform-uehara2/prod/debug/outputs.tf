output "ec2_security_group_id" {
  description = "EC2 instance security group ID for RDS access"
  value       = aws_security_group.ec2_db_restore_sg.id
}

output "ec2_instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.db_restore_ec2.id
}

output "temp_s3_bucket_name" {
  description = "Temporary S3 bucket name for DB restore"
  value       = aws_s3_bucket.temp_db_restore_bucket.id
}