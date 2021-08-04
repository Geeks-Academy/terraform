locals {
  s3_origin_id = "structureS3Origin"
  public_dns_entries = {
    "1" = "www.programmers-only.com"
  }

  private_dns_entries = {
    "1" = "www.programmers-only.com"
    "2" = "auth.programmers-only.com"
  }

  public_geeks_academy_dns_entries = {
    "1" = "www.geeks.academy"
    "4" = "structure-api.geeks.academy"
  }
}