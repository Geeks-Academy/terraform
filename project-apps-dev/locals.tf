locals {
  public_dns_entries = {
    "1" = "www.programmers-only.com"
    "2" = "programmers-only.com"
  }

  private_dns_entries = {
    "1" = "www.programmers.only"
    "2" = "programmers.only"
    "3" = "auth.programmers.only"
  }
}