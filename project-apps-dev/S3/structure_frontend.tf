resource "aws_s3_bucket" "structure_frontend" {
  bucket = "structure_frontend.geeks.academy"
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}
