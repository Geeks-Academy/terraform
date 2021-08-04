output "structure_frontend_domain_name" {
  value = aws_s3_bucket.structure_frontend.bucket_regional_domain_name
}

output "structure_domain_name" {
  value = aws_s3_bucket.structure.bucket_regional_domain_name
}