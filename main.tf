# S3 Bucket Configuration
resource "aws_s3_bucket" "mybucket" {
  bucket = var.bucketname
}

# Bucket Ownership Controls (use BucketOwnerPreferred)
resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.mybucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Block Public Access on the bucket (if you need it publicly accessible)
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.mybucket.id

  block_public_acls       = false  # Allow public ACLs
  block_public_policy     = false  # Allow public policies
  ignore_public_acls      = false  # Do not ignore public ACLs
  restrict_public_buckets = false  # Allow public buckets
}

# Do not specify ACL for the bucket or objects (ACL is handled by ownership controls)
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.mybucket.id
  key          = "index.html"
  source       = "index.html"
  content_type = "text/html"  # No ACL specified here
}

resource "aws_s3_object" "error" {
  bucket       = aws_s3_bucket.mybucket.id
  key          = "error.html"
  source       = "error.html"
  content_type = "text/html"  # No ACL specified here
}

# Configure Website Hosting for the Bucket
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.mybucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  depends_on = [aws_s3_bucket_public_access_block.example]
}
