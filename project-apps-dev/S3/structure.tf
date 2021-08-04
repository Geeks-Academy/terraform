resource "aws_s3_bucket" "structure" {
  bucket = "structure.geeks.academy"
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = ""
  }
}
