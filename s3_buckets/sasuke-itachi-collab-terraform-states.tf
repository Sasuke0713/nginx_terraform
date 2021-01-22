resource "aws_s3_bucket" "sasuke-itachi-collab-terraform-states" {
  bucket = "sasuke-itachi-collab-terraform-states"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled = true
  }

  tags = {
    Name        = "sasuke-itachi-collab-terraform-states"
    Environment = "Prototype"
  }
}

resource "aws_s3_bucket_public_access_block" "sasuke-itachi-collab-terraform-states" {
  bucket                  = aws_s3_bucket.sasuke-itachi-collab-terraform-states.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}