terraform {
  backend "s3" {
    bucket = "terraform-state-demonstration"
    key    = "development/paz"
    region = "us-east-1"
  }
}